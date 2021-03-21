% (C) Copyright 2021 CPP ROI developers

%
% scritps to transform a probability map from neurosynth
% into an image with fewer clusters (apply peak and extend threshold) and
% where each cluster has one label.
%

gunzip(fullfile('inputs', '*.gz'));

zMap = fullfile(pwd, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');
zMap = renameNeuroSynth(zMap);

peakThreshold = 5;
extendThreshold = 50;

zMap = renameNeuroSynth(zMap);

labeledClusters = labelClusters(zMap, peakThreshold, extendThreshold);

%% Use the ouput of the previous step
% to vizualize the image and figure out what is the label we want to extract.
labelStruct = struct('ROI', 'ns left MT', ...
                     'label', 1);

roiName = extractRoiByLabel(labeledClusters, labelStruct);
