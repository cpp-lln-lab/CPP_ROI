function copyAtlasToSpmDir(varargin)
  %
  % Copies a given atlas to the SPM atlas directory.
  %
  % USAGE::
  %
  %   copyAtlasToSpmDir(atlas, 'verbose', false)
  %
  % :param atlas: Any of ``{'AAL'}``. Defaults to ``'AAL'``
  % :type  atlas: char
  %
  % :param verbose: Defaults to ``false``
  % :type  verbose: boolean
  %
  %

  % (C) Copyright 2022 CPP ROI developers

  SUPPORTED_ATLASES = {'aal', 'hcpex'};

  args = inputParser;

  addOptional(args, 'atlas', 'AAL', @ischar);
  addParameter(args, 'verbose', false, @islogical);

  parse(args, varargin{:});

  atlas = args.Results.atlas;
  verbose = args.Results.verbose;

  spmAtlasDir = fullfile(spm('dir'), 'atlas');

  switch lower(atlas)

    case 'aal'
      sourceAtlasImage = fullfile(returnAtlasDir(), 'AAL3', 'AAL3v1_1mm.nii.gz');
      sourceAtlasXml = fullfile(returnAtlasDir(), 'AAL3', 'AAL3v1_1mm.xml');

    case 'hcpex'
      unzipAtlas(lower(atlas));
      sourceAtlasImage = fullfile(returnAtlasDir(lower(atlas)), 'HCPex.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(), 'HCPex.xml');

    case 'glasser'
      unzipAtlas(lower(atlas));
      sourceAtlasImage = fullfile(returnAtlasDir(lower(atlas)), ...
                                  'space-MNI152ICBM2009anlin_atlas-glasser_dseg.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(lower(atlas)), ...
                                'space-MNI152ICBM2009anlin_atlas-glasser_dseg.xml');

    otherwise
      error(['Only the following atlases can be copied to SPM atlas folder:\n', ...
             bids.internal.create_unordered_list(SUPPORTED_ATLASES)]);

  end

  targetAtlasImage = fullfile(spmAtlasDir, spm_file(sourceAtlasImage, 'filename'));
  targetAtlasXml = fullfile(spmAtlasDir, spm_file(sourceAtlasXml, 'filename'));

  atlasPresent = isdir(spmAtlasDir) && ...
                 exist(targetAtlasImage(1:end - 3), 'file') && ...
                 exist(targetAtlasXml, 'file');

  if ~atlasPresent
    if verbose
      fprintf('\nCopying atlas "%s" to spm atlas directory:\n\t%s\n', ...
              atlas, ...
              spmAtlasDir);
    end
    spm_mkdir(spmAtlasDir);

    copyfile(sourceAtlasImage, spmAtlasDir);

    unZippedAtlases = spm_select('FPList', spmAtlasDir, '.*.nii.gz');
    if ~isempty(unZippedAtlases)
      for i = 1:size(unZippedAtlases, 1)
        gunzip(deblank(unZippedAtlases(i, :)));
      end
      delete(fullfile(spmAtlasDir, '*.nii.gz'));
    end

    copyfile(sourceAtlasXml, spmAtlasDir);

  else
    if verbose
      fprintf('\nAtlas "%s" already in spm atlas directory:\n\t%s\n', ...
              atlas, ...
              spmAtlasDir);
    end

  end

end
