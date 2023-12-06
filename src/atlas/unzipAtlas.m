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

        if bids.internal.is_octave()
          gunzipWithOctave(cellstr(labelImages));
        else
          gunzip(cellstr(labelImages));
        end

      end

    case 'glasser'
      file = fullfile(atlasDir, 'Glasser', 'space-MNI152ICBM2009anlin_seg-glasser_dseg.nii');
      gunzipAtlasIfNecessary(file);

    case 'visfatlas'
      file = fullfile(atlasDir, 'visfAtlas', 'space-MNI_seg-visfAtlas_dseg.nii');
      gunzipAtlasIfNecessary(file);

    case 'hcpex'
      file = fullfile(returnAtlasDir('hcpex'), 'HCPex.nii');
      gunzipAtlasIfNecessary(file);

  end

end

function gunzipAtlasIfNecessary(file)
  if exist(file, 'file')
    return
  end

  file = [file '.gz'];
  if bids.internal.is_octave()
    gunzipWithOctave(file);
  else
    gunzip(file);
  end
end

function gunzipWithOctave(file)
  copyfile(file, [file '.bak']);
  gunzip(file);
  copyfile([file '.bak'], file);
end
