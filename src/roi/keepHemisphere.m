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
  % :param hemisphere: ``'L'`` or ``'R'``
  % :type hemisphere: string
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  % TODO change the hemi entity

  hdr = spm_vol(inputImage);
  vol = spm_read_vols(hdr);

  xDim = hdr.dim(1);
  xMid = round(xDim / 2);

  switch hemisphere

    case 'L'
      discard = 1:xMid;

    case 'R'
      discard = xMid:xDim;

    otherwise
      error('hemisphere must be L or R.');

  end

  vol(discard, :, :) = NaN;

  p = bids.internal.parse_filename(inputImage);
  p.entities.hemi = hemisphere;
  bidsFile = bids.File(p);

  hdr.fname = spm_file(inputImage, 'filename', bidsFile.filename);

  spm_write_vol(hdr, vol);

  outputImage = hdr.fname;

end
