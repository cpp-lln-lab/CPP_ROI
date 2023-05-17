% (C) Copyright 2020 CPP ROI developers

function test_suite = test_extractRoiFromAtlas() %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end


function test_extractRoiFromAtlas_glasser()

  roiImage = extractRoiFromAtlas(pwd, 'Glasser', 'FEF', 'L');

  assertEqual(exist(fullfile(pwd, 'hemi-L_space-MNI_atlas-glasser_label-FEF_mask.nii'), ...
                    'file'), ...
              2);

  vol =  spm_read_vols(spm_vol(roiImage));
  assertEqual(sum(vol(:) > 0), 13460); % check the ROI has the right number of voxel

  delete(fullfile(pwd, '*.nii'));
  delete(fullfile(pwd, '*.json'));

end

function test_extractRoiFromAtlas_wang()

  roiImage = extractRoiFromAtlas(pwd, 'wang', 'V1v', 'L');

  assertEqual(exist(fullfile(pwd, 'hemi-L_space-MNI_atlas-wang_label-V1v_mask.nii'), ...
                    'file'), ...
              2);

  vol =  spm_read_vols(spm_vol(roiImage));
  assertEqual(sum(vol(:) == 1), 3605); % check the ROI has the right number of voxel

  delete(fullfile(pwd, '*.nii'));
  delete(fullfile(pwd, '*.json'));

end

function test_extractRoiFromAtlas_neuromorphometrics()

  roiImage = extractRoiFromAtlas(pwd, 'neuromorphometrics', 'Amygdala', 'L');

  assertEqual(exist(fullfile(pwd, ...
                             'hemi-L_space-MNI_atlas-neuromorphometrics_label-Amygdala_mask.nii'), ...
                    'file'), ...
              2);

  vol =  spm_read_vols(spm_vol(roiImage));
  assertEqual(sum(vol(:) == 1), 375); % check the ROI has the right number of voxel

  delete(fullfile(pwd, '*.nii'));
  delete(fullfile(pwd, '*.json'));

end

function test_extractRoiFromAtlas_visfAtlas()

  roiImage = extractRoiFromAtlas(pwd, 'visfatlas', 'pFus', 'L');

  assertEqual(exist(fullfile(pwd, 'hemi-L_space-MNI_atlas-visfatlas_label-pFus_mask.nii'), ...
                    'file'), ...
              2);

  vol =  spm_read_vols(spm_vol(roiImage));
  assertEqual(sum(vol(:) == 1), 655); % check the ROI has the right number of voxel

  delete(fullfile(pwd, '*.nii'));
  delete(fullfile(pwd, '*.json'));

end

function test_extractRoiFromAtlas_hcpex()

  unzipAtlas('hcpex');

  roiImage = extractRoiFromAtlas(pwd, 'hcpex', 'MT', 'L');

  assertEqual(exist(fullfile(pwd, 'hemi-L_space-MNI_atlas-hcpex_label-MT_mask.nii'), ...
                    'file'), ...
              2);

  vol =  spm_read_vols(spm_vol(roiImage));
  assertEqual(sum(vol(:) == 1), 620); % check the ROI has the right number of voxel

  delete(fullfile(pwd, '*.nii'));
  delete(fullfile(pwd, '*.json'));

end
