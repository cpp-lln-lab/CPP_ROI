function test_suite = test_copyAtlasToSpmDir %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_copyAtlasToSpmDir_basic()

  if isGithubCi()
    return
  end

  copyAtlasToSpmDir('AAL', 'verbose', false);

  spmAtlasDir = fullfile(spm('dir'), 'atlas');

  targetAtlasImage = fullfile(spmAtlasDir, 'AAL3v1_1mm.nii');
  targetAtlasXml = fullfile(spmAtlasDir, 'AAL3v1_1mm.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

end

function test_copyAtlasToSpmDir_HPCex()

  if isGithubCi()
    return
  end

  copyAtlasToSpmDir('HCPex', 'verbose', false);

  spmAtlasDir = fullfile(spm('dir'), 'atlas');

  targetAtlasImage = fullfile(spmAtlasDir, 'HCPex.nii');
  targetAtlasXml = fullfile(spmAtlasDir, 'HCPex.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

end
