% (C) Copyright 2020 CPP ROI developers

function test_suite = test_getAtlasFilename %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getAtlasFilename_wang()

  rmRetinoAtlas();

  atlasFilename = getAtlasFilename('wang');
  assertEqual(size(atlasFilename, 1), 2);

  atlasFilename = getAtlasFilename('HCPex');
  assertEqual(size(atlasFilename, 1), 1);

  rmRetinoAtlas();

end

function test_getAtlasFilename_neuromorphometrics()

  expected = fullfile(returnAtlasDir(), 'space-IXI549Space_desc-neuromorphometrics_dseg.nii');

  try
    delete(expected);
  catch
  end

  atlasFilename = getAtlasFilename('neuromorphometrics');

  assertEqual(atlasFilename, expected);
  assertEqual(exist(expected, 'file'), 2);

end
