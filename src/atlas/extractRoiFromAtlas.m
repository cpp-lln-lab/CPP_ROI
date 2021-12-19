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
  % :param atlasName: ``wang``, ``neuromorphometrics``
  % :param roiName: run ``getLookUpTable(atlasName)`` to get a list of ROI names to choose from
  % :param hemisphere: ``L`` or ``R``
  % :type outputDir: string
  % :type atlasName: string
  % :type roiName: string
  % :type hemisphere: string
  %
  % (C) Copyright 2021 CPP ROI developers

  [atlasFile, lut] = getAtlasAndLut(atlasName);

  if strcmp(atlasName, 'wang')

    if strcmp(hemisphere, 'L')
      atlasFile = atlasFile(1, :);
    else
      atlasFile = atlasFile(2, :);
    end

    roiIdx = strcmp(roiName, lut.ROI);

  elseif strcmp(atlasName, 'neuromorphometrics')

    roiName = regexprep(roiName, '(Left )|(Right )', '');

    prefix = '';
    if strcmp(hemisphere, 'L')
      prefix = 'Left ';
    elseif strcmp(hemisphere, 'R')
      prefix = 'Right ';
    end

    roiIdx = strcmp([prefix roiName], lut.ROI);

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
                    'label', roiName, ...
                    'desc', atlasName);
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
