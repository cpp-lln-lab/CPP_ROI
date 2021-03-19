% (C) Copyright 2021 CPP ROI developers

function initCppRoi()
    
    global CPP_ROI_INITIALIZED
    
    if isempty(CPP_ROI_INITIALIZED)
        
        % directory with this script becomes the current directory
        WD = fileparts(mfilename('fullpath'));
        
        % we add all the subfunctions that are in the sub directories
        addpath(genpath(fullfile(WD, 'src')));
        addpath(fullfile(WD, 'lib', 'marsbar-0.44'));
        
        CPP_ROI_INITIALIZED = true();
        
    else
        fprintf('\n\nCPP_ROI already initialized\n\n');
        
    end
    
end
