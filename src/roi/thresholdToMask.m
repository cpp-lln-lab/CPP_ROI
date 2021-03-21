% (C) Copyright 2021 CPP ROI developers

function roiName = thresholdToMask(sourceImage, threshold)

  % TODO
  % allow threshold to be inferior than, greater than or both

  hdr = spm_vol(sourceImage);
  img = spm_read_vols(hdr);

  roi_hdr = hdr;

  p = bids.internal.parse_filename(sourceImage);
  p.type = 'mask';
  newName = createFilename(p);
  roi_hdr.fname = spm_file(roi_hdr.fname, 'filename', newName);

  img = img > threshold;

  spm_write_vol(roi_hdr, img);

  roiName = roi_hdr.fname;

end
