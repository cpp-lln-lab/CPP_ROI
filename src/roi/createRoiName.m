function roiName = createRoiName(mask, volumeDefiningImage)
  %
  %
  % (C) Copyright 2022 CPP ROI developers

  if strcmp(mask.def, 'sphere')

    bf = bids.File('');
    bf.extension = '.nii';
    bf.suffix = 'mask';

    if ~isempty(volumeDefiningImage)

      tmp = bids.File(volumeDefiningImage);

      % if the volume defining image has a space entity we reuse it
      if isfield(tmp.entities, 'space')
        entities.space = tmp.entities.space;
      end

    end

    label = '';
    if isfield(bf.entities, 'label')
      label = bf.entities.label;
    end

    entities.label = bids.internal.camel_case([label ' ' mask.label]);

    bf.entities = entities;

  else

    bf = bids.File(mask.global.hdr.fname);

    label = '';
    if isfield(bf.entities, 'label')
      label = bf.entities.label;
    end

    bf.entities.label = bids.internal.camel_case([label ' ' mask.label]);

  end

  roiName = bf.filename;

end
