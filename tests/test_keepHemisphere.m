% (C) Copyright 2020 CPP ROI developers

function test_suite = test_keepHemisphere %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_keepHemisphere_basic()

  inputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'demos', 'roi');

  gunzip(fullfile(inputDir, 'inputs', '*.gz'));
  zMap = fullfile(inputDir, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

  zMap = renameNeuroSynth(zMap);

  % keep only one hemisphere and appends a 'hemi-[hemisphere label]'
  leftRoiImage = keepHemisphere(zMap, 'L');
  rightRoiImage = keepHemisphere(zMap, 'R');

  assertEqual(exist(fullfile(inputDir, 'inputs', ...
                             'space-MNI_label-neurosynthVisualMotion_hemi-L_probseg.nii'), 'file'), 2);
  assertEqual(exist(fullfile(inputDir, 'inputs', ...
                             'space-MNI_label-neurosynthVisualMotion_hemi-R_probseg.nii'), 'file'), 2);

  % TODO check the data content

  delete(fullfile(inputDir, 'inputs', '*.nii'));

end
