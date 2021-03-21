function unzipAtlas()
    
    atlasFolder = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'atlas');
    
    file = fullfile(atlasFolder, 'visual_topography_probability_atlas.zip');
    
    unzip(file, fileparts(file))
    
    labelImages =  spm_select('FPList', ...
                                fullfile(atlasFolder, ...
                                'visual_topography_probability_atlas', ...
                                'subj_vol_all'), ...
                                '^maxprob_vol_.*h.nii.gz$');
    
    gunzip(cellstr(labelImages));
    
end