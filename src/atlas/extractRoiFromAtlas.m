function roiImage = extractRoiFromAtlas(outputDir, atlasName, roiName, hemisphere)
  %
  % Outputs a ROI image and side car json for a given atlas, roi name (as
  % defined in the look up table of that atlas) and a hemisphere
  %
  % USAGE::
  %
  %   roiImage = extractRoiFromAtlas(outputDir, atlasName, roiName, hemisphere)
  %
  % :param outputDir:
  % :param atlasName: ``'wang'``, ``'visfatlas'``, ``'neuromorphometrics'``, ``'hcpex'``
  % :param roiName: run ``getLookUpTable(atlasName)`` to get a list of ROI names to choose from
  % :param hemisphere: ``L`` or ``R``
  % :type outputDir: string
  % :type atlasName: string
  % :type roiName: string
  % :type hemisphere: string
  %

  % (C) Copyright 2021 CPP ROI developers

  if ~ismember(hemisphere, {'L', 'R'})

    error('\n Hemisphere label %s not valid, try "L" or "R"', hemisphere);

  end

  [atlasFile, lut] = getAtlasAndLut(atlasName);

  if strcmpi(atlasName, 'wang')

    if strcmpi(hemisphere, 'L')
      atlasFile = atlasFile(1, :);
    else
      atlasFile = atlasFile(2, :);
    end

    roiIdx = strcmp(roiName, lut.ROI);

  elseif strcmpi(atlasName, 'neuromorphometrics')

    roiName = regexprep(roiName, '(Left )|(Right )', '');

    prefix = '';
    if strcmp(hemisphere, 'L')
      prefix = 'Left ';
    elseif strcmp(hemisphere, 'R')
      prefix = 'Right ';
    end

    roiIdx = strcmp([prefix roiName], lut.ROI);

  elseif strcmpi(atlasName, 'visfatlas')

    prefix = '';
    if strcmp(hemisphere, 'L')
      prefix = 'lh_';
    elseif strcmp(hemisphere, 'R')
      prefix = 'rh_';
    end

    roiIdx = strcmp([prefix roiName], lut.ROI);

  elseif strcmpi(atlasName, 'hcpex')

    roiIdx = strcmp([hemisphere '_' roiName], lut.ROI);

  end

  % create ROI
  if isempty(roiIdx) || ~any(roiIdx)
    disp(lut.ROI);
    error('No ROI named %s for atlas %s. See list of available ROIs above', ...
          roiName, atlasName);
  end
  label = lut.label(roiIdx);

  labelStruct = struct('ROI', roiName, ...
                       'label', label);

  roiImage = extractRoiByLabel(atlasFile, labelStruct);

  % rename file
  entities = struct('hemi', hemisphere, ...
                    'space', 'MNI', ...
                    'atlas', atlasName, ...
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
