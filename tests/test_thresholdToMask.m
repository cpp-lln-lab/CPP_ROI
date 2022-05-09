function test_suite = test_thresholdToMask() %#ok<*STOUT>
  %
  % (C) Copyright 2021 CPP ROI developers

  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

% TODO refactor set up and teardown

function test_thresholdToMask_default()

  image = 'visual motion_association-test_z_FDR_0.01.nii.gz';

  inputImage = setUp(image);

  peakThreshold = 5.0;
  outputImage = thresholdToMask(inputImage, peakThreshold);

  % check that we have certain number voxels in the mask
  vol = spm_read_vols(spm_vol(outputImage));
  assertEqual(sum(vol(:) > 0), 2008);

  teardown();

end

function test_thresholdToMask_cluster()

  image = 'visual motion_association-test_z_FDR_0.01.nii.gz';

  inputImage = setUp(image);

  peakThreshold = 5;
  clusterSize = 10;
  outputImage = thresholdToMask(inputImage, peakThreshold, clusterSize);

  % check that we have certain number voxels in the mask
  vol = spm_read_vols(spm_vol(outputImage));
  assertEqual(sum(vol(:) > 0), 1926);

  teardown();

end

function inputImage = setUp(image)

  rootDir = fullfile(fileparts(mfilename('fullpath')), '..');

  gzImage = spm_file(fullfile(rootDir, 'demos', 'roi', 'inputs', image), 'cpath');
  [~, basename] = spm_fileparts(gzImage);
  gunzip(gzImage, pwd);

  inputImage = renameNeuroSynth(fullfile(pwd, basename));

end

function teardown()
  delete('*.nii');
  delete('*.json');
end
