function atlasFilename = getAtlasFilename(atlasName)
  %
  % Returns the atlas filename
  %
  % USAGE::
  %
  %   atlasFilename = getAtlasFilename(atlasName)
  %
  %

  % (C) Copyright 2021 CPP ROI developers

  atlasDir = returnAtlasDir(atlasName);

  isAKnownAtlas(atlasName);

  switch lower(atlasName)

    case 'wang'

      unzipAtlas('wang');

      atlasFilename = spm_select('FPList', ...
                                 fullfile(atlasDir, 'subj_vol_all'), ...
                                 '^.*_dseg.nii$');

    case 'neuromorphometrics'

      atlasFilename = fullfile(atlasDir, 'space-IXI549Space_desc-neuromorphometrics_dseg.nii');

      if ~exist(atlasFilename, 'file')
        copyfile(fullfile(spm('dir'), 'tpm', 'labels_Neuromorphometrics.nii'), ...
                 atlasFilename);
      end

    case 'anatomy_toobox'

      error('not implemented yet');

    case 'visfatlas'

      atlasFilename = fullfile(atlasDir, 'space-MNI_atlas-visfAtlas_dseg.nii');

    case 'hcpex'

      atlasFilename = fullfile(atlasDir, 'HCPex.nii');

    case 'glasser'

      atlasFilename = fullfile(atlasDir, 'space-MNI152ICBM2009anlin_atlas-glasser_dseg.nii');

  end

end
