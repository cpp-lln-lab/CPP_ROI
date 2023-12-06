function test_suite = test_labelClusters %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_labelClusters_basic

  zMap = fullfile(demoDir(), 'visual motion_association-test_z_FDR_0.01.nii');

  zMap = renameNeuroSynth(zMap);

  peakThreshold = 5;
  extendThreshold = 50;

  labeledClusters = labelClusters(zMap, peakThreshold, extendThreshold);

  expected = 'space-MNI_seg-neurosynth_label-visualMotion_dseg.nii';
  assertEqual(exist(fullfile(demoDir(), expected), 'file'), 2);

  labelStruct = struct('ROI', 'ns left MT', ...
                       'label', 1);

  roiName = extractRoiByLabel(labeledClusters, labelStruct);

  expected = 'space-MNI_seg-neurosynth_label-nsLeftMT_mask.nii';
  assertEqual(exist(fullfile(demoDir(), expected), 'file'), 2);

end

function value = thisDir()
  value = fullfile(fileparts(mfilename('fullpath')));
end

function value = demoDir()

  value = fullfile(thisDir(), '..', 'demos', 'roi', 'inputs');

  if exist(fullfile(value, 'visual motion_association-test_z_FDR_0.01.nii'), 'file') == 0
    gunzip(fullfile(value, '*.gz'));
  end

end
