function test_suite = test_isBinaryMask %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_isBinaryMask_true()

  [roiFilename, zMap] = prepareRoiAndVolumeDefiningImage();
  isBinaryMask(roiFilename);
  assertExceptionThrown(@()isBinaryMask(zMap), 'isBinaryMask:notBinaryImage');

end

function  [roiFilename, zMap] = prepareRoiAndVolumeDefiningImage()

  inputDir = setUpDemoData();

  zMap = fullfile(inputDir, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

  zMap = renameNeuroSynth(zMap);
  threshold = 10;
  roiFilename = thresholdToMask(zMap, threshold);

end
