function test_suite = test_isBinaryMask %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_isBinaryMask_true()

  roiFilename = prepareRoiAndVolumeDefiningImage();
  isBinaryMask(roiFilename);

end

function test_isBinaryMask_false()

  [~, zMap] = prepareRoiAndVolumeDefiningImage();
  assertExceptionThrown(@()isBinaryMask(zMap), 'isBinaryMask:notBinaryImage');

end

function value = thisDir()
  value = fileparts(mfilename('fullpath'));
end

function value = demoDir()

  value = fullfile(thisDir(), '..', 'demos', 'roi', 'inputs');

  if exist(fullfile(value, 'visual motion_association-test_z_FDR_0.01.nii'), 'file') == 0
    gunzip(fullfile(value, '*.gz'));
  end

end

function  [roiFilename, zMap] = prepareRoiAndVolumeDefiningImage()

  zMap = fullfile(demoDir(), 'space-MNI_atlas-neurosynth_label-visualMotion_probseg.nii');

  roiFilename = fullfile(demoDir(), ...
                         'space-MNI_atlas-neurosynth_label-visualMotion_desc-p10pt00_mask.nii');

  if exist(roiFilename, 'file') == 2

  else

    zMap = fullfile(demoDir(), 'visual motion_association-test_z_FDR_0.01.nii');

    zMap = renameNeuroSynth(zMap);

    threshold = 10;
    roiFilename = thresholdToMask(zMap, threshold);

  end

end
