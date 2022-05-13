function unzipAtlas(atlas)
  %
  % (C) Copyright 2021 CPP ROI developers

  atlasDir = returnAtlasDir();

  if strcmp(atlas, 'wang')

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
    
  elseif strcmp(atlas, 'visfAtlas')
      
      file = fullfile(atlasDir, 'visfAtlas/space-MNI_atlas-visfAtlas_dseg.nii.gz');
      
      gunzip(file);

  end

end
