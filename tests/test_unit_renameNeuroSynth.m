% (C) Copyright 2020 CPP ROI developers

function test_suite = test_unit_renameNeuroSynth %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_renameNeuroSynth_error()

  inputImage = fullfile(pwd, 'hMT.nii.gz');
  system(['touch ' inputImage]);

  assertExceptionThrown(@()renameNeuroSynth(inputImage), ...
                        'renameNeuroSynth:nonValidNeurosynthZmap');

  delete(inputImage);

end

function test_renameNeuroSynth()

  inputImage = fullfile(pwd, 'motion_association-test_z_FDR_0.01.nii.gz');
  system(['touch ' inputImage]);

  outputImage = renameNeuroSynth(inputImage);

  expected = fullfile(pwd, 'space-MNI_seg-neurosynth_label-motion_probseg.nii.gz');
  assertEqual(exist(outputImage, 'file'), 2);

  assertEqual(outputImage, expected);

  delete(expected);

end

function test_renameNeuroSynth_unzipped()

  inputImage = fullfile(pwd, 'motion_association-test_z_FDR_0.01.nii');
  system(['touch ' inputImage]);

  outputImage = renameNeuroSynth(inputImage);

  expected = fullfile(pwd, 'space-MNI_seg-neurosynth_label-motion_probseg.nii');
  assertEqual(exist(outputImage, 'file'), 2);

  assertEqual(outputImage, expected);

  delete(expected);

end
