function unzipAtlas(atlas)
  %

  % (C) Copyright 2021 CPP ROI developers

  atlasDir = returnAtlasDir();

  switch lower(atlas)

    case 'wang'

      file = fullfile(atlasDir, 'visual_topography_probability_atlas.zip');

      if ~exist(fullfile(atlasDir, 'visual_topography_probability_atlas'), 'dir')

        unzip(file, fileparts(file));

        labelImages =  spm_select('FPList', ...
                                  fullfile(atlasDir, ...
                                           'visual_topography_probability_atlas', ...
                                           'subj_vol_all'), ...
                                  '^.*_dseg.nii.gz$');

        gunzip(cellstr(labelImages));

      end

    case 'visfatlas'

      file = fullfile(atlasDir, 'visfAtlas/space-MNI_atlas-visfAtlas_dseg.nii.gz');

      gunzip(file);

    case 'hcpex'

      if exist(fullfile(returnAtlasDir('hcpex'), 'HCPex.nii'), 'file')
        return
      end

      file = fullfile(returnAtlasDir('hcpex'), 'HCPex.nii.gz');
      if isOctave()
        copyfile(file, fullfile(returnAtlasDir('hcpex'), 'HCPex.nii.gz.bak'));
      end

      gunzip(file);

  end

end
