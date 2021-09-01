function outputImage = extractRoiByLabel(sourceImage, labelStruct)
  %
  % Given a discrete segmentation source image fullpath and a look up table
  % label structure this creates a mask for that ROI and returns the fullpath to its BIDS name.
  % This will also create a JSON side car file for that image.
  %
  % USAGE::
  %
  %   outputImage = extractRoiByLabel(sourceImage, labelStruct)
  %
  % :param sourceImage: discrete segmentation source image fullpath
  % :type sourceImage: string
  % :param labelStruct: 1x1 structure with fields ``ROI`` for the ROI name
  %                     and ``label`` for the corresponding label
  % :type labelStruct: structure
  %
  % (C) Copyright 2021 CPP ROI developers

  hdr = spm_vol(sourceImage);
  vol = spm_read_vols(hdr);

  outputVol = false(size(vol));
  outputVol(vol == labelStruct.label) = true;

  p = bids.internal.parse_filename(sourceImage);
  p.entities.label = labelStruct.ROI;
  p.suffix = 'mask';
  p.use_schema = false;

  newName = bids.create_filename(p);
  hdr.fname = spm_file(hdr.fname, 'filename', newName);

  spm_write_vol(hdr, outputVol);
  outputImage = hdr.fname;

  json = bids.derivatives_json(outputImage);
  bids.util.jsonencode(json.filename, json.content);

end
