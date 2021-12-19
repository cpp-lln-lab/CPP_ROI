% (C) Copyright 2021 CPP ROI developers

function uninitCppRoi()

  global CPP_ROI_INITIALIZED
  global CPP_ROI_PATHS

  if isempty(CPP_ROI_INITIALIZED) || ~CPP_ROI_INITIALIZED
    fprintf('\n\nCPP_ROI not initialized\n\n');
    return

  else
    marsbar('off');
    rmpath(CPP_ROI_PATHS);
    CPP_ROI_INITIALIZED = false;

  end

end
