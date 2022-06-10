function test_suite = test_createRoiName %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_createRoiName_non_sphere()

  mask.def = 'expand';
  mask.global.hdr.fname = 'suffixOnly.nii';

  %%
  mask.label = '';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'mask.nii');

  mask.label = 'foo';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'label-foo_mask.nii');

  %%
  mask.global.hdr.fname = 'one-entity.nii';

  mask.label = '';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'one-entity_mask.nii');

  mask.label = 'foo';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'label-foo_one-entity_mask.nii');

end

function test_createRoiName_sphere()

  mask.def = 'sphere';

  %%
  mask.label = '';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'mask.nii');

  mask.label = 'foo';
  roiName = createRoiName(mask);
  assertEqual(roiName, 'label-foo_mask.nii');

  %%
  volumeDefiningImage = fullfile(pwd, 'TStatistic.nii');

  mask.label = '';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'mask.nii');

  mask.label = 'foo';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'label-foo_mask.nii');

  %%
  volumeDefiningImage = fullfile(pwd, 'space-MNI_TStatistic.nii');

  mask.label = '';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'space-MNI_mask.nii');

  mask.label = 'foo';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'space-MNI_label-foo_mask.nii');

end

function test_createRoiName_sphere_spm()

  % spm (ish) output

  % https://github.com/cpp-lln-lab/CPP_ROI/issues/6
  volumeDefiningImage = fullfile(pwd, 'task-auditory_p-0001_k-0_MC-none_label-001_spmT.nii');
  mask.def = 'sphere';
  mask.label = 'sphere5x44yMinus67z0';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'label-sphere5x44yMinus67z0_mask.nii');

  % https://github.com/cpp-lln-lab/CPP_ROI/issues/16
  volumeDefiningImage = fullfile(pwd, 'con_0001.niii');
  mask.def = 'sphere';
  mask.label = 'sphere5x44yMinus67z0';
  roiName = createRoiName(mask, volumeDefiningImage);
  assertEqual(roiName, 'label-sphere5x44yMinus67z0_mask.nii');

end
