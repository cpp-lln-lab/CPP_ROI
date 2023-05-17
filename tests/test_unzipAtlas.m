% (C) Copyright 2020 CPP ROI developers

function test_suite = test_unzipAtlas() %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_unzipAtlas_glasser()

  unzipAtlas('Glasser');
  
  expectedFile = fullfile(returnAtlasDir('Glasser'), ...
                             'space-MNI152ICBM2009anlin_atlas-glasser_dseg.nii');

  assertEqual(exist(expectedFile, 'file'), 2);

  delete(expectedFile);

end

function test_unzipAtlas_wang()

  cleanUp();

  unzipAtlas('wang');

  assertEqual(exist( ...
                    fullfile(returnAtlasDir('wang'), ...
                             'subj_vol_all', ...
                             'space-MNI_hemi-lh_dseg.nii'), ...
                    'file'), ...
              2);
end

function test_unzipAtlas_hcpex()

  unzipAtlas('hcpex');
  
  expectedFile = fullfile(returnAtlasDir('hcpex'), 'HCPex.nii');

  assertEqual(exist(expectedFile, 'file'), 2);
  
    delete(expectedFile);

end

function cleanUp()

  pause(1);

  if bids.internal.is_octave()
    confirm_recursive_rmdir (true, 'local');
  end

  try
    rmdir(returnAtlasDir('wang'), 's');
  catch
  end

end
