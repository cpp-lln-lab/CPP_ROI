% (C) Copyright 2020 CPP ROI developers

function test_suite = test_unit_renameFile %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_renameFile()

  inputFile = 'sub-03_task-test_bold.nii';
  system(['touch ' inputFile]);

  specification = struct('entities', struct('desc', 'renamed'));

  newName = renameFile(inputFile, specification);

  expected = 'sub-03_task-test_desc-renamed_bold.nii';
  assertEqual(exist(newName, 'file'), 2);

  assertEqual(newName, expected);

  delete(fullfile(pwd, 'sub-03_task-test_desc-renamed_bold.nii'));

end
