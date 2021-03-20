
gunzip(fullfile('inputs', '*.gz'));
probabilityMap = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

probabilityMap = renameNeuroSynth(probabilityMap);
roiImage = thresholdToMask(probabilityMap, 5);

% keep only one hemisphere and appends a 'hs--[hemisphere label]'
leftRoiImage = keepHemisphere(roiImage, 'lh');
rightRoiImage = keepHemisphere(roiImage, 'rh');

% change the label entity and remove the hs one
leftroiImage = renameFile(leftroiImage, ...
                          struct('label', 'ns left MT', ...
                                  'hs', ''));
rightRoiImage = renameFile(rightRoiImage, ...
                          struct('label', 'ns right MT', ...
                                  'hs', ''));                              
