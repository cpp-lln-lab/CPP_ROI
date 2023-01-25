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

        if isOctave()
          gunzipWithOctave(file);
        else
          gunzip(file);
        end

      end

    case 'visfatlas'

      file = fullfile(atlasDir, 'visfAtlas/space-MNI_atlas-visfAtlas_dseg.nii.gz');

      if isOctave()
        gunzipWithOctave(file);
      else
        gunzip(file);
      end

    case 'hcpex'

      if exist(fullfile(returnAtlasDir('hcpex'), 'HCPex.nii'), 'file')
        return
      end

      file = fullfile(returnAtlasDir('hcpex'), 'HCPex.nii.gz');
      if isOctave()
        gunzipWithOctave(file);
      else
        gunzip(file);
      end

  end

end

function gunzipWithOctave(file)
  copyfile(file, [file '.bak']);
  gunzip(file);
  copyfile([file '.bak'], file);
end
