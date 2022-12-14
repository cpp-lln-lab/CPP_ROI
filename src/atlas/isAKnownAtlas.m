function isAKnownAtlas(atlasName)
  % (C) Copyright 2021 CPP ROI developers
  if ~ismember(lower(atlasName), {'wang', ...
                                  'neuromorphometrics', ...
                                  'anatomy_toobox', ...
                                  'visfatlas', ...
                                  'hcpex'})
    % TODO throw a proper error here
    error('unknown atlas type');
  end
end
