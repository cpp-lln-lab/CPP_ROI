function value = tempDir()

  % (C) Copyright 2021 CPP ROI developers
  value = tempname();
  mkdir(value);
end
