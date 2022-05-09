function pth = cppRoiRoot()
  %
  %
  % USAGE::
  %
  %   pth = cppRoiRoot()
  %
  %
  % (C) Copyright 2022 CPP ROI developers

  pth = fullfile(fileparts(mfilename('fullpath')), '..', '..');
  pth = spm_file(pth, 'cpath');

end
