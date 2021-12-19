function vol = sortAndThresholdClusters(l2, num, clusterSize)
  %
  % (C) Copyright 2020 CPP ROI developers

  [n, ni] = sort(histc(l2(:), 0:num), 1, 'descend');
  vol  = zeros(size(l2));
  n  = n(2:end);
  ni = ni(2:end) - 1;
  ni = ni(n >= clusterSize);
  n  = n(n >= clusterSize);
  for i = 1:length(n)
    vol(l2 == ni(i)) = 1;
  end

end
