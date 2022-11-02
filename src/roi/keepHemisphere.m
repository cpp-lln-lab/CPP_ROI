function outputImage = keepHemisphere(inputImage, hemisphere)
  %
  % Only keep the values from one hemisphere. Sets the other half to NaN.
  % Writes an image with an extra entity ``_hemi-[R|L]``
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

  bf = bids.File(inputImage);
  bf.entity_order = cat(1, 'hemi', fieldnames(bf.entities));
  bf.entities.hemi = hemisphere;
  bf = bf.reorder_entities;

  hdr.fname = spm_file(inputImage, 'filename', bf.filename);

  if not(any(vol(:)))
    warning('This image will be empty:\n\t%s\n');
  end

  spm_write_vol(hdr, vol);

  outputImage = hdr.fname;

end
