% (C) Copyright 2021 CPP ROI developers

function initCppRoi()

  % directory with this script becomes the current directory
  WD = fileparts(mfilename('fullpath'));

  % we add all the subfunctions that are in the sub directories
  addpath(genpath(fullfile(WD, 'src')));
  addpath(genpath(fullfile(WD, 'lib', 'marsbar-0.44')));

end
