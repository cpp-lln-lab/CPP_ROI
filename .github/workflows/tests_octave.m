function tests_octave()

  %
  % (C) Copyright 2024 CPP ROI developers

  root_dir = getenv('GITHUB_WORKSPACE');

  addpath(fullfile(root_dir, 'spm12'));
  addpath(fullfile(root_dir, 'lib', 'bids-matlab'));
  addpath(fullfile(root_dir, 'MOcov', 'MOcov'));

  cd(fullfile(root_dir, 'MOxUnit', 'MOxUnit'));

  moxunit_set_path();

  cd(fullfile(root_dir));

  initCppRoi();

  run_tests();

end
