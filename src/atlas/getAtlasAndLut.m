function [atlasFile, lut] = getAtlasAndLut(atlasName)
  %
  % Gets the atlas image and the look up table of a given atlas
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  lut = getLookUpTable(atlasName);

  atlasFile = getAtlasFilename(atlasName);

end
