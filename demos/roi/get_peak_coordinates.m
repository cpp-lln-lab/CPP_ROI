% (C) Copyright 2020 CPP ROI developers

% Shows how to get the peak coordinate within a ROI
roiImage = extractRoiFromAtlas(pwd, 'wang', 'V1v', 'L');

% Data to read the maximum from
gunzip(fullfile(pwd, 'inputs', '*.gz'));
dataImage = fullfile(pwd, 'inputs', 'TStatistic.nii');

% If there is no value above a certain threshold the function will return NaN
threshold = 1;

% The image and the ROI must have the same dimension if we want to use the thresold option
reslicedImages = resliceRoiImages(dataImage, roiImage);

% Get to work.
[worldCoord, voxelCoord, maxVal] = getPeakCoordinates(dataImage, reslicedImages, threshold);
