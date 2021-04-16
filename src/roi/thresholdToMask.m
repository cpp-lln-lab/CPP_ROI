% (C) Copyright 2021 CPP ROI developers

function outputImage = thresholdToMask(inputImage, threshold)

  % TODO
  % allow threshold to be inferior than, greater than or both

  hdr = spm_vol(inputImage);
  img = spm_read_vols(hdr);

  p = bids.internal.parse_filename(inputImage);
  p.suffix = 'mask';
  newName = createFilename(p);
  hdr.fname = spm_file(hdr.fname, 'filename', newName);

  img = img > threshold;

  spm_write_vol(hdr, img);

  outputImage = hdr.fname;

end
