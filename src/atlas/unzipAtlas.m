function unzipAtlas()

  atlasDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'atlas');

  file = fullfile(atlasDir, 'visual_topography_probability_atlas.zip');

  unzip(file, fileparts(file));

  labelImages =  spm_select('FPList', ...
                            fullfile(atlasDir, ...
                                     'visual_topography_probability_atlas', ...
                                     'subj_vol_all'), ...
                            '^maxprob_vol_.*h.nii.gz$');

  gunzip(cellstr(labelImages));

end
