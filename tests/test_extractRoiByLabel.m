% (C) Copyright 2020 CPP ROI developers

function test_suite = test_extractRoiByLabel() %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_lut_wang()

  [atlasFile, lut] = getAtlasAndLut('neuromorphometrics');

  labelStruct = struct('ROI', lut.ROI{1}, ...
                       'label', lut.label(1));

  outputImage = extractRoiByLabel(atlasFile, labelStruct);

  assertEqual(exist(outputImage, 'file'), 2);

  vol =  spm_read_vols(spm_vol(outputImage));
  assertEqual(sum(vol(:) == 1), 291); % check the ROI has the right number of voxel

  delete(fullfile(returnAtlasDir(), '*.nii'));
  delete(fullfile(returnAtlasDir(), '*.json'));

end
