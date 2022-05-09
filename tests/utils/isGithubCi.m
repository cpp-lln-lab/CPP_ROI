function [IS_GITHUB, pth] = isGithubCi()
  %
  % (C) Copyright 2022 CPP ROI developers

  IS_GITHUB = false;

  GITHUB_WORKSPACE = getenv('HOME');

  if strcmp(GITHUB_WORKSPACE, '/home/runner')

    fprintf(1, '\n WE ARE RUNNING IN GITHUB CI\n');

    IS_GITHUB = true;
    pth = GITHUB_WORKSPACE;

  end

end
