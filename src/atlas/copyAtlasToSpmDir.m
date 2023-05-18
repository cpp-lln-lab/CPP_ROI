function copyAtlasToSpmDir(varargin)
  %
  % Copies a given atlas to the SPM atlas directory.
  %
  % USAGE::
  %
  %   copyAtlasToSpmDir(atlas, 'verbose', false)
  %
  % :param atlas: Any of ``{'aal', 'hcpex', 'glasser', 'visfatlas', 'wang'}``.
  %               Defaults to ``'AAL'``
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

  [sourceAtlasImage, sourceAtlasXml] = prepareFiles(atlas);

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

  if strcmpi(atlas, 'wang')
    delete(sourceAtlasImage);
  end

end

function [sourceAtlasImage, sourceAtlasXml] = prepareFiles(atlas)

  SUPPORTED_ATLASES = {'aal', 'hcpex', 'glasser', 'visfatlas', 'wang'};

  atlas = lower(atlas);
  switch atlas

    case 'aal'
      sourceAtlasImage = fullfile(returnAtlasDir(), 'AAL3', 'AAL3v1_1mm.nii.gz');
      sourceAtlasXml = fullfile(returnAtlasDir(), 'AAL3', 'AAL3v1_1mm.xml');

    case 'hcpex'
      sourceAtlasImage = fullfile(returnAtlasDir(atlas), 'HCPex.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(), 'HCPex.xml');

    case 'visfatlas'
      sourceAtlasImage = fullfile(returnAtlasDir(atlas), 'space-MNI_atlas-visfAtlas_dseg.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(atlas), 'space-MNI_atlas-visfAtlas_dseg.xml');

    case 'glasser'

      sourceAtlasImage = fullfile(returnAtlasDir(atlas), ...
                                  'space-MNI152ICBM2009anlin_atlas-glasser_dseg.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(atlas), ...
                                'space-MNI152ICBM2009anlin_atlas-glasser_dseg.xml');

    case 'wang'
      sourceAtlasImage = fullfile(returnAtlasDir(atlas), ...
                                  'subj_vol_all', ...
                                  'space-MNI_atlas-wang_dseg.nii');
      sourceAtlasXml = fullfile(returnAtlasDir(), ...
                                'space-MNI_atlas-wang_dseg.xml');

    otherwise
      error(['Only the following atlases can be copied to SPM atlas folder:\n', ...
             bids.internal.create_unordered_list(SUPPORTED_ATLASES)]);

  end

  if ismember(atlas, {'hcpex', 'glasser', 'visfatlas', 'wang'})
    if exist(sourceAtlasImage, 'file') ~= 2
      unzipAtlas(atlas);
    end
  end

  if strcmp(atlas, 'wang')
    % merge left and right
    files = spm_select('FPList', ...
                       fullfile(returnAtlasDir(lower(atlas)), 'subj_vol_all'), ...
                       '^space.*hemi.*nii$');
    hdr = spm_vol(files);
    vols = spm_read_vols(hdr);
    vol = sum(vols, 4);
    hdr =  hdr(1);
    hdr(1).fname = sourceAtlasImage;
    spm_write_vol(hdr, vol);
  end

end
