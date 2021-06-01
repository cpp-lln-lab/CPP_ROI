function outputImage = keepHemisphere(inputImage, hemisphere)
  %
  % Only keep the values from one hemisphere. Sets the other half to NaN.
  % Writes an image with an extra entity ``_hs-[hemisphere]``
  %
  % USAGE::
  %
  %   keepHemisphere(image, hemisphere)
  %
  % :param image:
  % :type image: string
  % :param hemisphere: ``'lh'`` or ``'rh'``
  % :type hemisphere: string
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  hdr = spm_vol(inputImage);
  vol = spm_read_vols(hdr);

  xDim = hdr.dim(1);
  xMid = round(xDim / 2);

  switch lower(hemisphere)

    case 'lh'
      discard = 1:xMid;

    case 'rh'
      discard = xMid:xDim;
  end

  vol(discard, :, :) = NaN;

  p = bids.internal.parse_filename(inputImage);
  p.entities.hs = lower(hemisphere);
  p.use_schema = false;
  newName = bids.create_filename(p);

  hdr.fname = spm_file(inputImage, 'filename', newName);

  spm_write_vol(hdr, vol);

  outputImage = hdr.fname;

end
