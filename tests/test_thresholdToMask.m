function test_suite = test_thresholdToMask() %#ok<*STOUT>

  % (C) Copyright 2021 CPP ROI developers

  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_thresholdToMask_default()

  inputDir = setUpDemoData();
  inputImage = fullfile(inputDir, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

  peakThreshold = 5.0;
  outputImage = thresholdToMask(inputImage, peakThreshold);

  % check that we have certain number voxels in the mask
  vol = spm_read_vols(spm_vol(outputImage));
  assertEqual(sum(vol(:) > 0), 2008);

end

function test_thresholdToMask_cluster()

  inputDir = setUpDemoData();
  inputImage = fullfile(inputDir, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

  peakThreshold = 5;
  clusterSize = 10;
  outputImage = thresholdToMask(inputImage, peakThreshold, clusterSize);

  % check that we have certain number voxels in the mask
  vol = spm_read_vols(spm_vol(outputImage));
  assertEqual(sum(vol(:) > 0), 1926);

end
