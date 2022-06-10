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
specification = struct('entities', struct('label', 'ns left motion', ...
                                          'hemi', ''));
bf = bids.File(leftRoiImage);
bf = bf.rename('spec', specification, 'dry_run', false, 'verbose', true);
leftRoiImage =  fullfile(bf.path, bf.filename);

specification.entities.label = 'ns right motion';
bf = bids.File(rightRoiImage);
bf = bf.rename('spec', specification, 'dry_run', false, 'verbose', true);
rightRoiImage =  fullfile(bf.path, bf.filename);
