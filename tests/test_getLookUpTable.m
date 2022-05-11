% (C) Copyright 2020 CPP ROI developers

function test_suite = test_getLookUpTable() %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_lut_wang()

  rmRetinoAtlas();

  lut = getLookUpTable('wang');

  assertEqual(lut.label, [1:25]');
  assertEqual(lut.ROI{1}, 'V1v');

  rmRetinoAtlas();

end

function test_lut_anat_tb()

  if ~isGithubCi

    lut = getLookUpTable('anatomy_toobox');

    assertEqual(lut.label(1), 7);
    assertEqual(lut.ROI{1}, 'Interposed Nucleus');

  end

end

function test_lut_neuromorpho()

  lut = getLookUpTable('neuromorphometrics');

  assertEqual(lut.label(1), 4);
  assertEqual(lut.ROI{1}, '3rd Ventricle');

end

function cleanUp()

  pause(1);

  if isOctave()
    confirm_recursive_rmdir (true, 'local');
  end
  rmdir(returnAtlasDir('wang'), 's');

end
