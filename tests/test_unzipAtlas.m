% (C) Copyright 2020 CPP ROI developers

function test_suite = test_unzipAtlas() %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_unzipAtlas_default()

  cleanUp();

  unzipAtlas('wang');

  assertEqual(exist( ...
                    fullfile(returnAtlasDir('wang'), ...
                             'subj_vol_all', ...
                             'space-MNI_hemi-lh_dseg.nii'), ...
                    'file'), ...
              2);

  unzipAtlas('hcpex');

  assertEqual(exist( ...
                    fullfile(returnAtlasDir('hcpex'), 'HCPex.nii'), ...
                    'file'), ...
              2);

  cleanUp();

end

function cleanUp()

  pause(1);

  if isOctave()
    confirm_recursive_rmdir (true, 'local');
  end

  try
    rmdir(returnAtlasDir('wang'), 's');
  catch
  end

end
