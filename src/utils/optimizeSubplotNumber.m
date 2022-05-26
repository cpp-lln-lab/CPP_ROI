function [m, n] = optimizeSubplotNumber(mn)
  %
  % (C) Copyright 2022 CPP ROI developers

  % Optimizes the number of subplot to have on a figure
  n  = round(mn^0.4);
  m  = ceil(mn / n);

end
