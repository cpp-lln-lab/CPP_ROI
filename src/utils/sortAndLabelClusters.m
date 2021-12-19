function vol = sortAndLabelClusters(l2, num, clusterSize)
  %
  % Creates a binary image after:
  % - Sorting clusters by their extent
  % - Removes cluster with smaller than clusterSize
  % - Labelling cluster with their rank in the sorting
  %
  % USAGE::
  %
  %   vol = sortAndLabelClusters(l2, num, clusterSize)
  %
  %
  % See also: getClusters, labelClusters
  %
  % (C) Copyright 2021 CPP ROI developers

  % refactor with sortAndThresholdClusters

  [n, ni] = sort(histc(l2(:), 0:num), 1, 'descend');
  vol  = zeros(size(l2));
  n  = n(2:end);
  ni = ni(2:end) - 1;
  ni = ni(n >= clusterSize);
  n  = n(n >= clusterSize);
  for i = 1:length(n)
    vol(l2 == ni(i)) = i;
  end

  fprintf('Selected %d clusters (out of %d) in image.\n', length(n), num);
  for i = 1:length(n)
    fprintf('Cluster label %i ; size: %i voxels\n', i, n(i));
  end

end
