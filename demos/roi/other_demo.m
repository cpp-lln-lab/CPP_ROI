% (C) Copyright 2021 CPP ROI developers

run ../../initCppRoi;

gunzip(fullfile('inputs', '*.gz'));
zMap = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

zMap = renameNeuroSynth(zMap);
roiImage = thresholdToMask(zMap, 5);

% keep only one hemisphere and appends a 'hs--[hemisphere label]'
leftRoiImage = keepHemisphere(roiImage, 'lh');
rightRoiImage = keepHemisphere(roiImage, 'rh');

% change the label entity and remove the hs one
leftRoiImage = renameFile(leftRoiImage, ...
                          struct('label', 'ns left motion', ...
                                 'hs', ''));
rightRoiImage = renameFile(rightRoiImage, ...
                           struct('label', 'ns right motion', ...
                                  'hs', ''));
