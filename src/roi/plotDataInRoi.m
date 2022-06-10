function figHandle = plotDataInRoi(varargin)
  %
  % Creates a figure showing a histogram of the content of a set of ROIs used on
  % a set of data files.
  %
  % ROI label is extracted from the label entity in the BIDS filename.
  %
  % USAGE::
  %
  %     figHandle = plotDataInRoi(dataImages, roiImages, ...
  %                                   'scaleFactor', 1, ...
  %                                   'roiAs', 'rows', ...
  %                                   'dataLabel', {})
  %
  % :param dataImages:
  % :type dataImages: path or cellstr of paths
  %
  % :param roiImages:
  % :type roiImages: path or cellstr of paths
  %
  % :param scaleFactor: value to scale the factor by. Default to  1.
  % :type scaleFactor: numerical
  %
  % :param roiAs: Determine if the ROI are supposed to be organized by rows or
  %               columns.
  %               Default to 'rows'.
  % :type roiAs: 'rows' or 'cols'
  %
  % :param dataLabel: strings to use to label the data rows or columns.
  % :type dataLabel: cellstr
  %
  % :param maxVox: max of scale for nb of voxels. Default to [].
  % :type maxVox: positive integer
  %
  % :param nbBins: use the same number of bins for all graphs.
  %                By default based on the number of unique values across all
  %                the datasets.
  % :type nbBins: positive integer
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
  rowOrCol =   @(x) ismember(x, {'rows', 'cols'});

  args = inputParser;

  args.addRequired('dataImages', isFile);
  args.addRequired('roiImages',  isFile);
  args.addParameter('scaleFactor', 1, @isnumeric);
  args.addParameter('roiAs', 'rows', rowOrCol);
  args.addParameter('dataLabel', {}, @iscellstr);
  args.addParameter('maxVox', [], @isnumeric);
  args.addParameter('nbBins', [], @isnumeric);

  args.parse(varargin{:});

  dataImages = args.Results.dataImages;
  roiImages = args.Results.roiImages;
  scaleFactor = args.Results.scaleFactor;
  roiAs = args.Results.roiAs;
  dataLabel = args.Results.dataLabel;
  nbBins = args.Results.nbBins;

  if ischar(dataImages)
    dataImages = {dataImages};
  end

  if ischar(roiImages)
    roiImages = {roiImages};
  end

  nbRois = numel(roiImages);
  nbData = numel(dataImages);

  if numel(dataLabel) ~= nbData
    warning('numel dataLabel must be equal to numel dataImages');
    dataLabel = {};
  end

  if strcmp(roiAs, 'rows')
    rows = nbRois;
    cols = nbData;
  elseif strcmp(roiAs, 'cols')
    cols = nbRois;
    rows = nbData;
  end

  figHandle = figure('position', [50 50 300 * cols 300 * rows]);

  %% collect info to adapt the graphs later on

  nbBinsList = [];

  % limit axis of axis for ROI (nb of voxels)
  MIN = [];
  MAX = [];

  % to plot all the modes
  modes = [];

  subplotList = [];

  idxSubplot = 1;

  for iRow = 1:rows

    for iCol = 1:cols

      if strcmp(roiAs, 'rows')
        data{idxSubplot} = spm_summarise(spm_vol(dataImages{iCol}), roiImages{iRow}) * scaleFactor;
      elseif strcmp(roiAs, 'cols')
        data{idxSubplot} = spm_summarise(spm_vol(dataImages{iRow}), roiImages{iCol}) * scaleFactor;
      end

      if isempty(data{idxSubplot})
        bins = nan;
      else
        [~, bins] = hist(data{idxSubplot}, defaultNbBins);
      end
      MAX(end + 1) = max(bins);
      MIN(end + 1) = min(bins);

      % modes and nbBins work better on rounded values
      modes(end + 1) = mode(round(data{idxSubplot}));
      nbBinsList(end + 1) = numel(unique(round(data{idxSubplot})));

      subplotList(iRow, iCol) = idxSubplot;

      idxSubplot = idxSubplot + 1;

    end

  end

  if isempty(nbBins)
    nbBins = max(nbBinsList);
  end

  maxVox = getMaxVox(args, data, nbBins);

  %% plot histogram and mode

  idxSubplot = 1;

  for iRow = 1:rows

    for iCol = 1:cols

      subplot(rows, cols, idxSubplot);

      hold on;

      if ~isempty(data{idxSubplot})

        hist(data{idxSubplot}, nbBins);

        plot([modes(idxSubplot) modes(idxSubplot)], ...
             [0 max(maxVox)], ...
             '--r', ...
             'linewidth', 1);

        t = text(max(MAX) * 0.5, ...
                 max(maxVox) * 0.85, ...
                 sprintf('mean=%0.2f', mean(data{idxSubplot})));

        set(t, 'FontSize', 10);

      end

      axis([min(MIN) max(MAX) 0 max(maxVox)]);

      idxSubplot = idxSubplot + 1;

    end

  end

  labelAxis(roiAs, rows, cols, subplotList, roiImages, dataLabel);

end

function labelAxis(roiAs, rows, cols, subplotList, roiImages, dataLabel)

  if strcmp(roiAs, 'rows')

    for i = 1:cols
      subplot(rows, cols, subplotList(end, i));
      xlabel('intensities');
    end

    for i = 1:rows

      subplot(rows, cols, subplotList(i, 1));

      bf = bids.File(roiImages{i});
      l = ylabel(sprintf('roi: %s\nnb voxels', bf.entities.label));
      set(l, 'FontWeight', 'bold');

    end

  else

    for i = 1:cols

      subplot(rows, cols, subplotList(1, i));

      bf = bids.File(roiImages{i});
      desc = '';
      if isfield(bf.entities, 'desc')
        desc = sprintf('- desc: %s', bf.entities.desc);
      end
      title(sprintf('roi: %s%s', bf.entities.label, desc));

      subplot(rows, cols, subplotList(end, i));

      xlabel('nb voxels');

    end

    for i = 1:rows

      subplot(rows, cols, subplotList(i, 1));

      label = '';
      if ~isempty(dataLabel)
        label = dataLabel{i};
      end
      l = ylabel(sprintf('%s', label));
      set(l, 'FontWeight', 'bold');

    end

  end

end

function maxVox = getMaxVox(args, data, nbBins)

  maxVox = args.Results.maxVox;

  if isempty(maxVox)

    for i = 1:numel(data)

      tmp = hist(data{i}, nbBins);

      if isempty(tmp)
        maxVox(end + 1) = nan;
      else
        maxVox(end + 1) = max(tmp);
      end

    end

  end

end
