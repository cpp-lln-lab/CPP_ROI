% (C) Copyright 2020 CPP ROI developers

function test_suite = test_getPeakCoordinates %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getPeakCoordinates_basic()

  roiImage = extractRoiFromAtlas(pwd, 'wang', 'V1v', 'L');

  dataImage = fullfile(demoDir(), 'TStatistic.nii');

  reslicedImages = resliceRoiImages(dataImage, roiImage);

  [worldCoord, voxelCoord, maxVal] = getPeakCoordinates(dataImage, reslicedImages);

  assertEqual(worldCoord, [-3 -91 -1]);
  assertEqual(voxelCoord, [28 8 24]);
  assertElementsAlmostEqual(maxVal, 1.6212, 'absolute', 1e-3);

  delete('*hemi-L_space-MNI_atlas-wang_label-V1v_mask.*');

end

function value = thisDir()
  value = fullfile(fileparts(mfilename('fullpath')));
end

function value = demoDir()

  value = fullfile(thisDir(), '..', 'demos', 'roi', 'inputs');

  if exist(fullfile(value, 'TStatistic.nii'), 'file') == 0
    gunzip(fullfile(value, '*.gz'));
  end

end
