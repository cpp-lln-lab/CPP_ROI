function [l2, num] = getClusters(inputImage, peakThreshold)
  %
  % USAGE::
  %
  %   [l2, num] = getClusters(inputImage, peakThreshold)
  %
  % :param sourceImage: string
  % :type sourceImage: string
  % :param peakThreshold: string
  % :type peakThreshold: string
  %
  % See also labelClusters, sortAndLabelClusters
  %
  % (C) Copyright 2021 CPP ROI developers

  hdr = spm_vol(inputImage);
  vol = spm_read_vols(hdr);

  [l2, num] = spm_bwlabel(double(vol > peakThreshold), 26);

end
