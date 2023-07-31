function isAKnownAtlas(atlasName)
  % (C) Copyright 2021 CPP ROI developers
  if ~ismember(lower(atlasName), supportedAtlases())
    msg = sprintf('Suppored atlases are: %s\nGot: "%s"', ...
                  bids.internal.create_unordered_list(supportedAtlases()), ...
                  lower(atlasName));
    bids.internal.error_handling(mfilename(), ...
                                 'unknownAtlas', msg, false);
  end
end
