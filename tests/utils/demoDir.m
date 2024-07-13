function value = demoDir()

  % (C) Copyright 2021 CPP ROI developers
  value = fullfile(thisDir(), '..', '..', 'demos');
end

function value = thisDir()
  value = fileparts(mfilename('fullpath'));
end
