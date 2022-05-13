function status = isBinaryMask(image)
  %
  % (C) Copyright 2022 CPP ROI developers

  status = true;

  if exist(image, 'file') == 0
    err.identifier =  'isBinaryMask:notAFile';
    err.message = sprintf(['the image:', ...
                           '\n\t%s\n'...
                           'does not exist.'], ...
                          image);
    error(err);
  end

  hdr = spm_vol(image);

  if numel(hdr) > 1
    err.identifier =  'isBinaryMask:notBinaryImage';
    err.message = sprintf(['the image:', ...
                           '\n\t%s\n', ...
                           'must be a 3D image. It seems to be 4D image with %i volume.'], ...
                          image);
    error(err);
  end

  vol = spm_read_vols(hdr);

  if numel(unique(vol)) > 2 || ~all(unique(vol) == [0; 1])
    err.identifier =  'isBinaryMask:notBinaryImage';
    err.message = sprintf(['the image:', ...
                           '\n\t%s\n', ...
                           'must be a binary image. It seems to more than ones and zeros.'], ...
                          image);
    error(err);
  end

end
