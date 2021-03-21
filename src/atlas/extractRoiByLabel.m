% (C) Copyright 2021 CPP ROI developers

function outputImage = extractRoiByLabel(sourceImage, labelStruct)

  hdr = spm_vol(sourceImage);
  vol = spm_read_vols(hdr);

  outputVol = false(size(vol));
  outputVol(vol == labelStruct.label) = true;

  p = bids.internal.parse_filename(sourceImage);
  p.label = labelStruct.ROI;
  p.type = 'mask';
  newName = createFilename(p);
  hdr.fname = spm_file(hdr.fname, 'filename', newName);

  % Cluster labels as their size.
  spm_write_vol(hdr, outputVol);
  outputImage = hdr.fname;

end
