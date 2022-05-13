function roiName = createRoiName(varargin)
  %
  % creates BIDS like filename for ROIs
  %
  % USAGE::
  %
  %     roiName = createRoiName(mask, volumeDefiningImage)
  %
  % (C) Copyright 2022 CPP ROI developers

  args = inputParser;

  args.addRequired('mask', @isstruct);
  args.addOptional('volumeDefiningImage', '', @ischar);

  args.parse(varargin{:});

  type = args.Results.mask.def;
  label = args.Results.mask.label;
  mask = args.Results.mask;
  volumeDefiningImage = args.Results.volumeDefiningImage;

  if strcmp(type, 'sphere')

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

    tmp = '';
    if isfield(bf.entities, 'label')
      tmp = bf.entities.label;
    end

    entities.label = bids.internal.camel_case([tmp ' ' label]);

    bf.entities = entities;

  else

    bf = bids.File(mask.global.hdr.fname);

    bf.suffix = 'mask';

    tmp = '';
    if isfield(bf.entities, 'label')
      tmp = bf.entities.label;
    end

    bf.entities.label = bids.internal.camel_case([tmp ' ' label]);

  end

  bf = bf.reorder_entities();
  bf = bf.update;
  roiName = bf.filename;

end
