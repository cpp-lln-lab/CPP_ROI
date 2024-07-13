% (C) Copyright 2020 CPP ROI developers

function test_suite = test_getPeakCoordinates %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getPeakCoordinates_basic()

  inputDir = setUpDemoData();
  dataImage = fullfile(inputDir, 'inputs', 'TStatistic.nii');

  roiImage = extractRoiFromAtlas(pwd, 'wang', 'V1v', 'L');

  reslicedImages = resliceRoiImages(dataImage, roiImage);

  [worldCoord, voxelCoord, maxVal] = getPeakCoordinates(dataImage, reslicedImages);

  assertEqual(worldCoord, [-3 -91 -1]);
  assertEqual(voxelCoord, [28 8 24]);
  assertElementsAlmostEqual(maxVal, 1.6212, 'absolute', 1e-3);

end
