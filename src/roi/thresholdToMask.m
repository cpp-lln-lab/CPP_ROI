function outputImage = thresholdToMask(inputImage, threshold)
  %
  % TODO
  % allow threshold to be inferior than, greater than or both
  %
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  hdr = spm_vol(inputImage);
  img = spm_read_vols(hdr);

  p = bids.internal.parse_filename(inputImage);
  p.suffix = 'mask';
  p.use_schema = false;
  newName = bids.create_filename(p);

  hdr.fname = spm_file(hdr.fname, 'filename', newName);
  img = img > threshold;
  spm_write_vol(hdr, img);

  outputImage = hdr.fname;

  json = bids.derivatives_json(outputImage);
  bids.util.jsonencode(json.filename, json.content);

end
