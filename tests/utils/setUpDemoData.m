function inputDir = setUpDemoData()

  % (C) Copyright 2021 CPP ROI developers

  inputDir = fullfile(demoDir(), 'roi');

  tmpDir = tempDir();
  copyfile(inputDir, tmpDir);

  inputDir = tmpDir;
  if bids.internal.is_octave()
    inputDir = fullfile(tmpDir, 'roi');
  end

  gunzip(fullfile(inputDir, 'inputs', '*.gz'));
end
