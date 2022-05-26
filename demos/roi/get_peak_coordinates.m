roiImage = extractRoiFromAtlas(pwd, 'wang', 'V1v', 'L');

gunzip(fullfile(pwd, 'inputs', '*.gz'));
dataImage = fullfile(pwd, 'inputs', 'TStatistic.nii');

reslicedImages = resliceRoiImages(dataImage, roiImage);

[worldCoord, voxelCoord, maxVal] = getPeakCoordinates(dataImage, reslicedImages);
