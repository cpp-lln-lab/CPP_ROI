function outputImage = thresholdToMask(varargin)
  %
  % Returns a binary mask for an image after applying voxel wise threshold and
  % an optional cluster size threshold
  %
  % USAGE::
  %
  %   outputImage = thresholdToMask(inputImage, peakThreshold, clusterSize)
  %
  % :param inputImage:
  % :type inputImage: path
  % :param peakThreshold:
  % :type peakThreshold: float
  % :param clusterSize:
  % :type clusterSize: integer >= 0 (Default)
  %
  % :returns: - :outputImage: (string)
  %

  % (C) Copyright 2021 CPP ROI developers

  % TODO
  % allow threshold to be inferior than, greater than or both

  default_clusterSize = 0;

  isFile = @(x) exist(x, 'file') == 2;
  isPositive = @(x) isnumeric(x) && x >= 0;

  args = inputParser;

  addRequired(args, 'inputImage', isFile);
  addRequired(args, 'peakThreshold', @isnumeric);
  addOptional(args, 'clusterSize', default_clusterSize, isPositive);

  parse(args, varargin{:});

  inputImage = args.Results.inputImage;
  peakThreshold = args.Results.peakThreshold;
  clusterSize = args.Results.clusterSize;
  [l2, num] = getClusters(inputImage, peakThreshold);
  vol = sortAndThresholdClusters(l2, num, clusterSize);

  % create output name
  bf = bids.File(inputImage);

  bf.suffix = 'mask';

  % add peakThreshold and clusterSizeInfo to desc
  if ~isfield(bf.entities, 'desc')
    bf.entities(1).desc = '';
  end
  descSuffix = sprintf('p%05.2f', peakThreshold);
  if clusterSize > 0
    descSuffix = [descSuffix, sprintf('k%03.0f', clusterSize)];
  end
  descSuffix = strrep(descSuffix, '.', 'pt');
  bf.entities.desc = [bf.entities.desc descSuffix];

  if isempty(bf.extension)
    bf.extension = '.nii';
  end

  bf = bf.update();

  hdr = spm_vol(inputImage);
  hdr.fname = spm_file(hdr.fname, 'filename', bf.filename);
  outputImage = hdr.fname;

  spm_write_vol(hdr, vol);

  json = bids.derivatives_json(outputImage);
  bids.util.jsonencode(json.filename, json.content);

end
