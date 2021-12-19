function rootDir = rootDir()
  %
  % USAGE::
  %
  %   rootDir = rootDir()
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  rootDir = fullfile(fileparts(mfilename('fullpath')), '..', '..');

end
