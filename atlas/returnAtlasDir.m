function atlasDir = returnAtlasDir(atlas)
  %
  % USAGE::
  %
  %   atlasDir = returnAtlasDir(atlas)
  %
  % :parameter atlas: atlas to use (``''``, ``wang``, ``anatomy_toobox``,
  % ``neuromorphometric``)
  % :type atlas: string
  %
  % (C) Copyright 2021 CPP ROI developers

  atlasDir = fileparts(mfilename('fullpath'));

  if nargin > 0

    switch lower(atlas)

      case 'wang'
        atlasDir = fullfile(atlasDir, 'visual_topography_probability_atlas');

      case 'anatomy_toobox'
        atlasDir = fullfile(spm('dir'), 'toolbox', 'Anatomy');

      case 'visfatlas'
        atlasDir = fullfile(atlasDir, 'visfAtlas');

      case 'hcpex'
        atlasDir = fullfile(atlasDir, 'HCPex', 'HCPex_v1.0');

      case 'glasser'
        atlasDir = fullfile(atlasDir, 'Glasser');

      case 'neuromorphometrics'

      otherwise
        error('unknown atlas type');
    end

  end

  atlasDir = spm_file(atlasDir, 'cpath');

end
