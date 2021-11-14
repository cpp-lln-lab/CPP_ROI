% (C) Copyright 2020 CPP ROI developers

% demo showing how to create an intersection between 2 binary masks
%
% ROI 1: we will use the probability map for visual motion from Neurosynth
%        link: https://neurosynth.org/analyses/terms/visual%20motion/
%
% ROI 2: we will create a binary mask from the SPM gray matter tissue
%        probability map
%
% We will then intersect the 2 images.
%

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
roi_1 = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

opt.unzip.do = true;
opt.save.roi = true;
opt.outputDir = []; % if this is empty new masks are saved in the current directory.
if opt.save.roi
  opt.reslice.do = true;
else
  opt.reslice.do = false;
end

roi_1 = prepare_roi(opt, roi_1);

roi_2 = create_roi(opt.outputDir);

specification  = struct( ...
                        'mask1', roi_1, ...
                        'mask2', roi_2);

volumeDefiningImage = roi_2;

mask = createRoi('intersection', specification, volumeDefiningImage, opt.outputDir, opt.save.roi);

%% HELPER FUNCTION

function [roiName, roi] = prepare_roi(opt, roi)

  if opt.unzip.do
    gunzip(fullfile('inputs', '*.gz'));
  end

  % give the neurosynth map a name that is more bids friendly
  %
  % space-MNI_label-neurosynthKeyWordsUsed_probseg.nii
  %
  roi = renameNeuroSynth(roi);

  % Threshold probability map into a binary mask
  % to keep only values above a certain threshold
  threshold = 10;
  roiName = thresholdToMask(roi, threshold);
  roiName = removeSpmPrefix(roiName, spm_get_defaults('realign.write.prefix'));

end

function [roi] = create_roi(output_dir)

  if isempty(output_dir)
    output_dir = pwd;
  end

  tpm_file = fullfile(spm('dir'), 'tpm', 'TPM.nii');
  hdr = spm_vol(tpm_file);
  hdr = hdr(1); % the first volume corrsponds to the grey matter
  vol = spm_read_vols(hdr);
  vol = vol > 0.5;

  p = struct('suffix', 'mask', ...
             'ext', '.nii', ...
             'use_schema', false, ...
             'entities', struct('space', 'IXI549Space', ...
                                'label', 'GM'));

  filename = bids.create_filename(p);

  roi = fullfile(output_dir, filename);

  hdr.fname = roi;

  spm_write_vol(hdr, vol);

end
