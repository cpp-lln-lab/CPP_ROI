function roiImage = extractRoiFromAtlas(varargin)
  %
  % Outputs a ROI image and side car json for a given atlas, roi name (as
  % defined in the look up table of that atlas) and a hemisphere
  %
  % USAGE::
  %
  %   roiImage = extractRoiFromAtlas(outputDir, atlasName, roiName, hemisphere)
  %
  % :param outputDir:
  % :type outputDir: string
  %
  % :param atlasName: ``'wang'``, ``'visfatlas'``,
  %                   ``'neuromorphometrics'``, ``'hcpex'``,
  %                   ``'glasser'``
  % :type atlasName: string
  %
  % :param roiName: run ``getLookUpTable(atlasName)`` to get a list of ROI names to choose from
  % :type roiName: string
  %
  % :param hemisphere: ``L`` or ``R``
  % :type hemisphere: string
  %
  %
  % EXAMPLE::
  %
  %     outputDir = pwd;
  %     atlasName = 'neuromorphometrics';
  %     roiName = 'PCu precuneus';
  %     hemisphere = 'R';
  %
  %     extractRoiFromAtlas(outputDir, atlasName, roiName, hemisphere)
  %

  % (C) Copyright 2021 CPP ROI developers

  isChar = @(x) ischar(x);

  args = inputParser;

  addRequired(args, 'outputDir', isChar);
  addRequired(args, 'atlasName', @(x) isAKnownAtlas(x));
  addRequired(args, 'roiName', isChar);
  addRequired(args, 'hemisphere', @(x) ismember(x, {'L', 'R'}));

  parse(args, varargin{:});

  outputDir = args.Results.outputDir;
  atlasName = args.Results.atlasName;
  roiName = args.Results.roiName;
  hemisphere = args.Results.hemisphere;

  [atlasFile, lut] = getAtlasAndLut(atlasName);

  switch lower(atlasName)
    case 'wang'

      if strcmpi(hemisphere, 'L')
        atlasFile = atlasFile(1, :);
      else
        atlasFile = atlasFile(2, :);
      end

      roiIdx = strcmp(roiName, lut.ROI);

    case 'neuromorphometrics'

      roiName = regexprep(roiName, '(Left )|(Right )', '');

      prefix = '';
      if strcmp(hemisphere, 'L')
        prefix = 'Left ';
      elseif strcmp(hemisphere, 'R')
        prefix = 'Right ';
      end

      roiIdx = strcmp([prefix roiName], lut.ROI);

    case 'visfatlas'

      prefix = '';
      if strcmp(hemisphere, 'L')
        prefix = 'lh_';
      elseif strcmp(hemisphere, 'R')
        prefix = 'rh_';
      end

      roiIdx = strcmp([prefix roiName], lut.ROI);

    case 'hcpex'

      roiIdx = strcmp([hemisphere '_' roiName], lut.ROI);

    case 'glasser'
      warning(['The volumetric version of the Glasser atlas is not ideally suited ', ...
               'to be used for standard brain-mapping approaches ', ...
               'that use volumetric nonlinear deformations.']);
      roiIdx = strcmp(roiName, lut.ROI);

  end

  % create ROI
  if isempty(roiIdx) || ~any(roiIdx)
    disp(sort(lut.ROI));
    error('No ROI named %s for atlas %s. See list of available ROIs above', ...
          roiName, atlasName);
  end
  label = lut.label(roiIdx);

  labelStruct = struct('ROI', roiName, ...
                       'label', label);

  roiImage = extractRoiByLabel(atlasFile, labelStruct);

  if strcmpi(atlasName, 'glasser')
    tmp = roiImage;
    roiImage = keepHemisphere(tmp, hemisphere, false);
    delete(tmp);
    delete(spm_file(tmp, 'ext', '.json'));
  end

  % rename file
  entities = struct('hemi', hemisphere, ...
                    'space', 'MNI', ...
                    'seg', lower(atlasName), ...
                    'label', roiName);
  nameStructure = struct('entities', entities, ...
                         'suffix', 'mask', ...
                         'ext', '.nii');
  bidsFile = bids.File(nameStructure);

  movefile(roiImage, fullfile(outputDir, bidsFile.filename));

  % create side car json
  roiImage = fullfile(outputDir, bidsFile.filename);
  json = bids.derivatives_json(roiImage);
  bids.util.jsonencode(json.filename, json.content);

end
