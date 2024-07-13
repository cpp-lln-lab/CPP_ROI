function rmRetinoAtlas()

  % (C) Copyright 2021 CPP ROI developers

  pause(0.3);

  if bids.internal.is_octave()
    confirm_recursive_rmdir (true, 'local');
  end

  try
    rmdir(returnAtlasDir('wang'), 's');
  catch
  end

end
