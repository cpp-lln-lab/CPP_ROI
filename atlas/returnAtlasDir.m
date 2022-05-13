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

    switch atlas

      case 'wang'
        atlasDir = fullfile(atlasDir, 'visual_topography_probability_atlas');

      case 'anatomy_toobox'
        atlasDir = fullfile(spm('dir'), 'toolbox', 'Anatomy');

      case 'visfAtlas'
        atlasDir = fullfile(atlasDir, 'visfAtlas');

    end

  end

  atlasDir = spm_file(atlasDir, 'cpath');

end
