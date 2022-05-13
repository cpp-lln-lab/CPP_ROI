% (C) Copyright 2021 CPP ROI developers

clear all;
clc;

% options : 'wang', 'neuromorphometrics', 'anatomy_toobox', 'visfAtlas'
opt.roi.atlas = 'visfAtlas'; 

% to get the list of possible run `getLookUpTable(opt.roi.atlas)`
opt.roi.name = {'pFus', 'mFus', 'CoS'};
opt.roi.dir = fullfile(pwd, 'derivatives', 'cpp_roi', 'group');

spm_mkdir(opt.roi.dir);

hemi = {'L', 'R'};

for iHemi = 1:numel(hemi)

  for iROI = 1:numel(opt.roi.name)

    roiName = opt.roi.name{iROI};

    imageName = extractRoiFromAtlas(opt.roi.dir, opt.roi.atlas, roiName, hemi{iHemi});

  end

end
