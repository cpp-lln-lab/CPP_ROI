% (C) Copyright 2020 CPP ROI developers

function test_suite = test_keepHemisphere %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_keepHemisphere_basic()

  inputDir = setUpDemoData();
  zMap = fullfile(inputDir, 'inputs', 'visual motion_association-test_z_FDR_0.01.nii');

  zMap = renameNeuroSynth(zMap);

  % keep only one hemisphere and add a 'hemi-[hemisphere label]' entity
  leftRoiImage = keepHemisphere(zMap, 'L');
  rightRoiImage = keepHemisphere(zMap, 'R');

  basename = 'space-MNI_seg-neurosynth_label-visualMotion_probseg.nii';

  assertEqual(exist(fullfile(inputDir, 'inputs', ...
                             ['hemi-L_' basename]), ...
                    'file'), ...
              2);
  assertEqual(exist(fullfile(inputDir, 'inputs', ...
                             ['hemi-R_' basename]), ...
                    'file'), ...
              2);

end
