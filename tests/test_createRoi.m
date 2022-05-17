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

  basename = 'label-sphere5x44yMinus67z0_mask';

  assertEqual(exist(fullfile(thisDir(), [basename '.nii']), 'file'), 2);
  assertEqual(exist(fullfile(thisDir(), [basename '.json']), 'file'), 2);

  delete(fullfile(thisDir(), '*.nii'));
  delete(fullfile(thisDir(), '*.json'));

  mask = createRoi('sphere', sphere, volumeDefiningImage, outputDir, false);

  assertEqual(exist(fullfile(thisDir(), [basename '.json']), 'file'), 0);
  assertEqual(exist(fullfile(thisDir(), [basename '.json']), 'file'), 0);

end

function test_createRoi_intersection_mask_sphere()

  [roiFilename, volumeDefiningImage] = prepareRoiAndVolumeDefiningImage();

  sphere.location = [44 -67 0];
  sphere.radius = 5;

  specification  = struct('mask1', roiFilename, ...
                          'mask2', sphere);

  saveImg = true;
  outputDir = thisDir();

  mask = createRoi('intersection', specification, volumeDefiningImage, outputDir, saveImg);

  basename = 'space-MNI_atlas-neurosynth_label-visualMotionIntersection_desc-p10pt00_mask';

  assertEqual(exist(fullfile(thisDir(), [basename '.nii']), 'file'), 2);
  assertEqual(exist(fullfile(thisDir(), [basename '.json']), 'file'), 2);

  delete(fullfile(thisDir(), '*.nii'));
  delete(fullfile(thisDir(), '*.json'));

end

function test_createRoi_expand

  [roiFilename, volumeDefiningImage] = prepareRoiAndVolumeDefiningImage();

  sphere.location = [44 -67 0];
  sphere.radius = 5;
  sphere.maxNbVoxels = 50;

  specification  = struct('mask1', roiFilename, ...
                          'mask2', sphere);

  saveImg = true;
  outputDir = thisDir();

  mask = createRoi('expand', specification, volumeDefiningImage, outputDir, saveImg);

  basename = 'space-MNI_atlas-neurosynth_label-visualMotionExpandVox57_desc-p10pt00_mask';

  assertEqual(mask.roi.size, 57);

  assertEqual(exist(fullfile(thisDir(), [basename '.nii']), 'file'), 2);
  assertEqual(exist(fullfile(thisDir(), [basename '.json']), 'file'), 2);

  delete(fullfile(thisDir(), '*.nii'));
  delete(fullfile(thisDir(), '*.json'));

end

function value = thisDir()
  value = fullfile(fileparts(mfilename('fullpath')));
end

function value = demoDir()

  value = fullfile(thisDir(), '..', 'demos', 'roi', 'inputs');

  if exist(fullfile(value, 'TStatistic.nii'), 'file') == 0 || ...
     exist(fullfile(value, 'visual motion_association-test_z_FDR_0.01.nii'), 'file') == 0
    gunzip(fullfile(value, '*.gz'));
  end

end

function  [roiFilename, volumeDefiningImage] = prepareRoiAndVolumeDefiningImage()

  volumeDefiningImage = fullfile(demoDir(), 'TStatistic.nii');

  roiFilename = fullfile(demoDir(), ...
                         'space-MNI_atlas-neurosynth_label-visualMotion_desc-p10pt00_mask.nii');

  if exist(roiFilename, 'file') == 2

  else

    zMap = fullfile(demoDir(), 'visual motion_association-test_z_FDR_0.01.nii');

    zMap = renameNeuroSynth(zMap);
    zMap = resliceRoiImages(volumeDefiningImage, zMap);

    zMap = removePrefix(zMap, 'r');

    threshold = 10;
    roiFilename = thresholdToMask(zMap, threshold);

  end

end
