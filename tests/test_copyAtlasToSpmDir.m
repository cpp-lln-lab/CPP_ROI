function test_suite = test_copyAtlasToSpmDir %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_copyAtlasToSpmDir_wang()

  copyAtlasToSpmDir('wang', 'verbose', false);

  targetAtlasImage = fullfile(spmAtlasDir(), ...
                              'space-MNI_atlas-wang_dseg.nii');
  targetAtlasXml = fullfile(spmAtlasDir(), ...
                            'space-MNI_atlas-wang_dseg.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

  cleanSpmAtlasDir();

end

function test_copyAtlasToSpmDir_visfatlas()

  copyAtlasToSpmDir('visfatlas', 'verbose', false);

  targetAtlasImage = fullfile(spmAtlasDir(), ...
                              'space-MNI_atlas-visfAtlas_dseg.nii');
  targetAtlasXml = fullfile(spmAtlasDir(), ...
                            'space-MNI_atlas-visfAtlas_dseg.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

  cleanSpmAtlasDir();

end

function test_copyAtlasToSpmDir_glasser()

  copyAtlasToSpmDir('Glasser', 'verbose', false);

  targetAtlasImage = fullfile(spmAtlasDir(), ...
                              'space-MNI152ICBM2009anlin_atlas-glasser_dseg.nii');
  targetAtlasXml = fullfile(spmAtlasDir(), ...
                            'space-MNI152ICBM2009anlin_atlas-glasser_dseg.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

  cleanSpmAtlasDir();

end

function test_copyAtlasToSpmDir_basic()

  copyAtlasToSpmDir('AAL', 'verbose', false);

  targetAtlasImage = fullfile(spmAtlasDir(), 'AAL3v1_1mm.nii');
  targetAtlasXml = fullfile(spmAtlasDir(), 'AAL3v1_1mm.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

  cleanSpmAtlasDir();

end

function test_copyAtlasToSpmDir_HPCex()

  copyAtlasToSpmDir('HCPex', 'verbose', false);

  targetAtlasImage = fullfile(spmAtlasDir(), 'HCPex.nii');
  targetAtlasXml = fullfile(spmAtlasDir(), 'HCPex.xml');

  assertEqual(exist(targetAtlasImage, 'file'), 2);
  assertEqual(exist(targetAtlasXml, 'file'), 2);

  cleanSpmAtlasDir();

end

function value = spmAtlasDir()
  value = fullfile(spm('dir'), 'atlas');
end

function cleanSpmAtlasDir()
  delete(fullfile(spmAtlasDir, '*.nii'));
  delete(fullfile(spmAtlasDir, '*.xml'));
end
