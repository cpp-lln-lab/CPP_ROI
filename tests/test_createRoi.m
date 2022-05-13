function test_suite = test_createRoi %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_createRoi_sphere()

  volumeDefiningImage = fullfile(demoDir(), 'TStatistic.nii');

  sphere.location = [44 -67 0];
  sphere.radius = 5;

  saveImg = true;
  outputDir = thisDir();

  mask = createRoi('sphere', sphere, volumeDefiningImage, outputDir, saveImg);

  assertEqual(exist(fullfile(thisDir(), 'label-sphere5x44yMinus67z0_mask.nii'), 'file'), 2);
  assertEqual(exist(fullfile(thisDir(), 'label-sphere5x44yMinus67z0_mask.json'), 'file'), 2);

  delete(fullfile(thisDir(), '*.nii'));
  delete(fullfile(thisDir(), '*.json'));

  mask = createRoi('sphere', sphere, volumeDefiningImage, outputDir, false);

  assertEqual(exist(fullfile(thisDir(), 'label-sphere5x44yMinus67z0_mask.nii'), 'file'), 0);
  assertEqual(exist(fullfile(thisDir(), 'label-sphere5x44yMinus67z0_mask.json'), 'file'), 0);

end

function value = thisDir()
  value = fullfile(fileparts(mfilename('fullpath')));
end

function value = demoDir()
  value = fullfile(thisDir(), '..', 'demos', 'roi', 'inputs');
  gunzip(fullfile(value, '*.gz'));
end
