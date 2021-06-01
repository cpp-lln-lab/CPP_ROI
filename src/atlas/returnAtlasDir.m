function atlasDir = returnAtlasDir(atlas)
  %
  % (C) Copyright 2021 CPP ROI developers

  atlasDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'atlas');

  if nargin > 0

    switch atlas

      case 'wang'
        atlasDir = fullfile(atlasDir, 'visual_topography_probability_atlas');

      case 'anatomy_toobox'
        atlasDir = fullfile(spm('dir'), 'toolbox', 'Anatomy');

    end

  end

  atlasDir = spm_file(atlasDir, 'cpath');

end
