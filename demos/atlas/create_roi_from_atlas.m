opt.roi.atlas = 'wang';
opt.roi.name = {'V1v', 'V1d'};
opt.roi.dir = fullfile(pwd, 'derivatives', 'cpp_roi', 'group');

spm_mkdir(opt.roi.dir);

hemi = {'lh', 'rh'};

for iHemi = 1:numel(hemi)

  for iROI = 1:numel(opt.roi.name)

    roiName = opt.roi.name{iROI};

    imageName = extractRoiFromAtlas(opt.roi.dir, opt.roi.atlas, roiName, hemi{iHemi});

  end

end
