% (C) Copyright 2021 CPP ROI developers

function test_suite = test_createFilename %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_createFilenameBasic()

  p.ext = '.nii';
  p.type = 'bold';
  p.sub = '01';
  p.task = 'face repetition';
  p.run = '01';

  newName = createFilename(p);

  assertEqual(newName, 'sub-01_task-faceRepetition_run-01_bold.nii');

end
