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
      sourceAtlasImage = fullfile(returnAtlasDir('hcpex'), 'HCPex.nii.gz');
      sourceAtlasXml = fullfile(returnAtlasDir(), 'HCPex.xml');

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
    gunzip(fullfile(spmAtlasDir, '*.nii.gz'));
    delete(fullfile(spmAtlasDir, '*.nii.gz'));

    copyfile(sourceAtlasXml, spmAtlasDir);

  else
    if verbose
      fprintf('\nAtlas "%s" already in spm atlas directory:\n\t%s\n', ...
              atlas, ...
              spmAtlasDir);
    end

  end

end
