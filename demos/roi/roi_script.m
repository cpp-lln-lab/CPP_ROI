% (C) Copyright 2020 CPP ROI developers

%% examples to create ROIs and extract data
%
% ROI: use the probability map for visual motion from Neurosynth
%   link: https://neurosynth.org/analyses/terms/visual%20motion/
%
% Data: tmap of Listening > Baseline from the MoAE demo

clear;
clc;

run ../../initCppRoi;

%% ASSUMPTION
%
% This assumes that the 2 images are in the same space (MNI, individual)
% but they might not necessarily have the same resolution.
%
% In SPM lingo this means they are coregistered but not necessarily resliced.
%

%% IMPORTANT: for saving ROIs
%
% If you want to save the ROI you are creating, you must make sure that the ROI
% image you are using DOES have the same resolution as the image you will
% sample.
%
% You can use the resliceRoiImages for that.

%%
zMap = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');
dataImage = fullfile(pwd, 'inputs', 'TStatistic.nii');

opt.unzip.do = true;
opt.save.roi = true;
opt.outputDir = []; % if this is empty new masks are saved in the current directory.
if opt.save.roi
  opt.reslice.do = true;
else
  opt.reslice.do = false;
end

% all of these functions can be found below and show you how to create ROIs and
% / or ROIs to extract data from an image.
%
[roiName, zMap] = prepareDataAndROI(opt, dataImage, zMap);

data_mask = getDataFromMask(dataImage,  roiName);
data_sphere = getDataFromSphere(opt, dataImage);
data_intersection = getDataFromIntersection(opt, dataImage,  roiName);
data_expand = getDataFromExpansion(opt, dataImage,  roiName);

%% Mini functions

% only to show how each case works

function data_mask = getDataFromMask(dataImage, roiName)

  data_mask = spm_summarise(dataImage, roiName);

end

function data_sphere = getDataFromSphere(opt, dataImage)

  % X Y Z coordinates of right V5 in millimeters
  location = [44 -67 0];

  % radius in millimeters
  radius = 5;

  sphere.location = location;
  sphere.radius = radius;

  mask = createRoi('sphere', sphere, dataImage, opt.outputDir, opt.save.roi);

  data_sphere = spm_summarise(dataImage, mask);

  % equivalent to
  % b = spm_summarise(dataImage, ...
  %                   struct( ...
  %                          'def', 'sphere', ...
  %                          'spec', radius, ...
  %                          'xyz', location'));

end

function data_intersection = getDataFromIntersection(opt, dataImage,  roiName)
  %
  % Gets the voxels at the intersection of:
  % - a binary mask and user defined sphere
  % - TODO: 2 binary masks
  %

  % X Y Z coordinates of right V5 in millimeters
  location = [44 -67 0];

  sphere.location = location;
  sphere.radius = 5;

  specification  = struct( ...
                          'mask1', roiName, ...
                          'mask2', sphere);

  mask = createRoi('intersection', specification, dataImage, opt.outputDir, opt.save.roi);

  data_intersection = spm_summarise(dataImage, mask.roi.XYZmm);

end

function data_expand = getDataFromExpansion(opt, dataImage,  roiName)
  %
  % will expand a ROI with a series of expanding spheres but within the
  % constrains of a binary mask
  %
  % the expansion stops once the number of voxels goes above a user defined
  % threshold.
  %

  % X Y Z coordinates of right V5 in millimeters
  location = [44 -67 0];

  sphere.location = location;
  sphere.radius = 1; % starting radius
  sphere.maxNbVoxels = 50;

  specification  = struct('mask1', roiName, ...
                          'mask2', sphere);

  mask = createRoi('expand', specification, dataImage, opt.outputDir, opt.save.roi);

  data_expand = spm_summarise(dataImage, mask.roi.XYZmm);

end

%% HELPER FUNCTION

function [roiName, zMap] = prepareDataAndROI(opt, dataImage, zMap)

  if opt.unzip.do
    gunzip(fullfile('inputs', '*.gz'));
  end

  % give the neurosynth map a name that is more bids friendly
  %
  % space-MNI_label-neurosynthKeyWordsUsed_probseg.nii
  %
  zMap = renameNeuroSynth(zMap);

  if opt.reslice.do
    % If needed reslice probability map to have same resolution as the data image
    %
    % resliceImg won't do anything if the 2 images have the same resolution
    %
    % if you read the data with spm_summarise,
    % then the 2 images do not need the same resolution.
    zMap = resliceRoiImages(dataImage, zMap);
  end

  % Threshold probability map into a binary mask
  % to keep only values above a certain threshold
  threshold = 10;
  roiName = thresholdToMask(zMap, threshold);
  roiName = removePrefix(roiName, spm_get_defaults('realign.write.prefix'));

end
