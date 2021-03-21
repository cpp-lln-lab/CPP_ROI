% (C) Copyright 2021 CPP ROI developers

function outputImage = labelClusters(sourceImage, peakThreshold, extendThreshold)

  % Adapted from:
  % https://en.wikibooks.org/wiki/SPM/How-to#How_to_remove_clusters_under_a_certain_size_in_a_binary_mask?

  hdr = spm_vol(sourceImage);

  [l2, num] = getClusters(hdr, peakThreshold);

  if ~num
    warning('No clusters found.');
    return
  end

  vol = sortAndLabelClusters(l2, num, extendThreshold);

  % Write new image with cluster laebelled with their voxel size
  p = bids.internal.parse_filename(sourceImage);
  p.type = 'dseg'; % discrete segmentation
  newName = createFilename(p);
  hdr.fname = spm_file(hdr.fname, 'filename', newName);

  % Cluster labels as their size.
  spm_write_vol(hdr, vol);
  outputImage = hdr.fname;

end

function [l2, num] = getClusters(hdr, peakThreshold)
  data = spm_read_vols(hdr);
  [l2, num] = spm_bwlabel(double(data > peakThreshold), 26);
end

function vol = sortAndLabelClusters(l2, num, extendThreshold)

  % Extent threshold, and sort clusters by their extent
  % Label corresponds to their rank
  [n, ni] = sort(histc(l2(:), 0:num), 1, 'descend');
  vol  = zeros(size(l2));
  n  = n(2:end);
  ni = ni(2:end) - 1;
  ni = ni(n >= extendThreshold);
  n  = n(n >= extendThreshold);
  for i = 1:length(n)
    vol(l2 == ni(i)) = i;
  end

  fprintf('Selected %d clusters (out of %d) in image.\n', length(n), num);
  for i = 1:length(n)
    fprintf('Cluster label %i ; size: %i voxels\n', i, n(i));
  end

end
