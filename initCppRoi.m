% (C) Copyright 2021 CPP ROI developers

function initCppRoi()

  global CPP_ROI_INITIALIZED
  global CPP_ROI_PATHS

  if isempty(CPP_ROI_INITIALIZED)

    % directory with this script becomes the current directory
    thisDirectory = fileparts(mfilename('fullpath'));

    % we add all the subfunctions that are in the sub directories
    CPP_ROI_PATHS = genpath(fullfile(thisDirectory, 'src'));
    CPP_ROI_PATHS = cat(2, CPP_ROI_PATHS, ':', ...
                fullfile(thisDirectory, 'lib', 'marsbar-0.44'));
    
    marsbar('on');
    try
      marsbar('splash');
    catch
    end

    addpath(CPP_ROI_PATHS, '-begin');
    CPP_ROI_INITIALIZED = true();

  else
    fprintf('\n\nCPP_ROI already initialized\n\n');

  end

end
