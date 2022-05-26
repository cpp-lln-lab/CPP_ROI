function figHandle = plotDataInRoi(varargin)
  %
  % Creates a figure showing a histogram of the content of a set of ROIs used on
  % a set of data files.
  %
  % USAGE::
  %
  %     figHandle = plotDataInRoi(dataImages, roiImages)
  %
  % :param dataImages:
  % :type dataImages: path or cellstr of paths
  %
  % :param roiImages:
  % :type roiImages: path or cellstr of paths
  %
  %
  % EXAMPLE::
  %
  %     mask1 = fullfile(pwd, 'label-V1_mask.nii')
  %     mask2 = fullfile(pwd, 'label-V2_mask.nii')
  %
  %     data1 = fullfile(pwd, 'label-0001_beta.nii')
  %     data2 = fullfile(pwd, 'label-0002_beta.nii')
  %
  %     mask = cellstr(cat(1, mask1, mask2));
  %     data = cellstr(cat(1, data1, data2));
  %
  %     plotDataInRoi(data, mask);
  %
  %
  % (C) Copyright 2022 CPP ROI developers

  defaultNbBins = 100;

  isFile = @(x) iscellstr(x) || exist(x, 'file') == 2;

  args = inputParser;

  args.addRequired('dataImages', isFile);
  args.addRequired('roiImages',  isFile);

  args.parse(varargin{:});

  dataImages = args.Results.dataImages;
  roiImages = args.Results.roiImages;

  if ischar(dataImages)
    dataImages = {dataImages};
  end

  if ischar(roiImages)
    roiImages = {roiImages};
  end

  nbRois = numel(roiImages);
  nbData = numel(dataImages);

  if nbRois == 1 || nbData == 1
    [rows, cols] = optimizeSubplotNumber(nbRois * nbData);
  else
    rows = nbRois;
    cols = nbData;
  end

  figHandle = figure('position', [50 50 300 * rows 300 * cols]);

  %% collect info to adapt the graphs later on

  % y scale
  maxVox = [];

  % x axis
  MIN = [];
  MAX = [];

  % use the same number of bins for all graphs
  % based on the minimum number of unique values across all the datasets
  nbBins = [];

  % to plot all the modes
  modes = [];

  subplotList = [];

  idxSubplot = 1;

  for iRoi = 1:nbRois

    for iData = 1:nbData

      data{idxSubplot} = spm_summarise(spm_vol(dataImages{iData}), roiImages{iRoi});

      [~, bins] = hist(data{idxSubplot}, defaultNbBins);
      MAX(end + 1) = max(bins);
      MIN(end + 1) = min(bins);

      % modes and nbBins work better on rounded values
      modes(end + 1) = mode(round(data{idxSubplot}));
      nbBins(end + 1) = numel(unique(round(data{idxSubplot})));

      subplotList(iRoi, iData) = idxSubplot;

      idxSubplot = idxSubplot + 1;

    end

  end

  nbBins = min(nbBins);

  for i = 1:numel(data)
    tmp = hist(data{i}, nbBins);
    maxVox(end + 1) = max(tmp);
  end

  %% plot histogram and mode

  idxSubplot = 1;

  for iRoi = 1:nbRois

    for iData = 1:nbData

      subplot(rows, cols, idxSubplot);

      hold on;

      hist(data{idxSubplot}, nbBins);

      plot([modes(idxSubplot) modes(idxSubplot)], ...
           [0 max(maxVox)], ...
           '--r', ...
           'linewidth', 1);

      bf = bids.File(roiImages{iRoi});
      title(['roi: ' bf.entities.label]);

      axis([min(MIN) max(MAX) 0 max(maxVox)]);

      idxSubplot = idxSubplot + 1;

    end

  end

  for i = 1:cols
    subplot(rows, cols, subplotList(end, i));
    xlabel('intensities');
  end

  for i = 1:rows
    subplot(rows, cols, subplotList(i, 1));
    ylabel('nb voxels');
  end

end
