% (C) Copyright 2020 CPP ROI developers

function test_suite = test_unit_returnAtlasDir %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_returnAtlasDir_no_input()

  atlasDir = returnAtlasDir();

  assertEqual(atlasDir, baseAtlasDir());

end

function test_returnAtlasDir_default()

  atlasDir = returnAtlasDir('neuromorphometric');

  assertEqual(atlasDir, baseAtlasDir());

end

function test_returnAtlasDir_wang()

  atlasDir = returnAtlasDir('wang');

  expected = fullfile(baseAtlasDir(),  'visual_topography_probability_atlas');

  assertEqual(atlasDir, expected);

end

function test_returnAtlasDir_anatomy_toobox()

  atlasDir = returnAtlasDir('anatomy_toobox');

  expected = fullfile(spm('dir'), 'toolbox', 'Anatomy');

  assertEqual(atlasDir, expected);

end

function baseDir = baseAtlasDir()

  baseDir = spm_file(fullfile(rootDir(), 'atlas'), 'cpath');

end
