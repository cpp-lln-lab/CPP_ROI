function atlasFilename = getAtlasFilename(atlasName)
  %
  % Returns the atlas filename
  %
  % "Probabilistic Maps of Visual Topography in Human Cortex"
  %
  % USAGE::
  %
  %   atlasFilename = getAtlasFilename(atlasName)
  %
  %
  %   DOI 10.1093/cercor/bhu277
  %   PMCID: PMC4585523
  %   PMID: 25452571
  %   Probabilistic Maps of Visual Topography in Human Cortex
  %
  % (C) Copyright 2021 CPP ROI developers

  atlasDir = returnAtlasDir(atlasName);

  if ~ismember(atlasName, {'wang', 'neuromorphometrics', 'anatomy_toobox', 'visfAtlas'})
    % TODO throw a proper error here
    error('unknown atlas type');
  end

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

  end

end
