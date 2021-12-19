function outputImage = labelClusters(varargin)
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
  % :type clusterSize: integer >= 0 (Default: 0)
  %
  % :returns: - :outputImage: (string)
  %
  % See also getClusters, sortAndLabelClusters
  %
  % Adapted from:
  % https://en.wikibooks.org/wiki/SPM/How-to#How_to_remove_clusters_under_a_certain_size_in_a_binary_mask?
  %
  % (C) Copyright 2021 CPP ROI developers

  default_clusterSize = 0;

  isFile = @(x) exists(x, 'file') == 2;
  isPositive = @(x) isinteger(x) && X >= 0;

  p = inputParser;

  addRequired(p, 'inputImage', isFile);
  addRequired(p, 'peakThreshold', @isnumeric);
  addOptional(p, 'clusterSize', default_clusterSize, isPositive);

  parse(p, varargin{:});

  inputImage = p.Results.inputImage;
  peakThreshold = p.Results.peakThreshold;
  clusterSize = p.Results.clusterSize;

  [l2, num] = getClusters(inputImage, peakThreshold);

  if ~num
    warning('No clusters found.');
    return
  end

  vol = sortAndLabelClusters(l2, num, clusterSize);

  % Write new image with cluster laebelled with their voxel size
  p = bids.internal.parse_filename(inputImage);
  p.suffix = 'dseg'; % discrete segmentation

  hdr = spm_vol(inputImage);
  bidsFile = bids.File(p);
  hdr.fname = spm_file(hdr.fname, 'filename', bidsFile.filename);

  % Cluster labels as their size.
  spm_write_vol(hdr, vol);
  outputImage = hdr.fname;

  json = bids.derivatives_json(outputImage);
  bids.util.jsonencode(json.filename, json.content);

end
