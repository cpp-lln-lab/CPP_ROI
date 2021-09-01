% (C) Copyright 2021 CPP ROI developers

% small demo to show how to create and rename ROIs that come from neurosynth
% and how to only keep the data from one hemisphere of an image.

run ../../initCppRoi;

gunzip(fullfile('inputs', '*.gz'));
zMap = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

zMap = renameNeuroSynth(zMap);
roiImage = thresholdToMask(zMap, 5);

% keep only one hemisphere and appends a 'hs--[hemisphere label]'
leftRoiImage = keepHemisphere(roiImage, 'L');
rightRoiImage = keepHemisphere(roiImage, 'R');

% change the label entity and remove the hs one
leftRoiImage = renameFile(leftRoiImage, ...
                          struct('entities', struct( ...
                                                    'label', 'ns left motion', ...
                                                    'hemi', '')));
rightRoiImage = renameFile(rightRoiImage, ...
                           struct('entities', struct( ...
                                                     'label', 'ns right motion', ...
                                                     'hemi', '')));
