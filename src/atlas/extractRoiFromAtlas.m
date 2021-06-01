function roiImage = extractRoiFromAtlas(roiDir, atlas, roiName, hemisphere)
  %
  % (C) Copyright 2021 CPP ROI developers

  if strcmp(atlas, 'wang')

    [maxProbaFiles, roiLabels] = getRetinoProbaAtlas();

    if strcmp(hemisphere, 'lh')
      sourceImage = maxProbaFiles(1, :);
    else
      sourceImage = maxProbaFiles(2, :);
    end

  end

  roiIdx = strcmp(roiName, roiLabels.ROI);
  label = roiLabels.label(roiIdx);

  labelStruct = struct('ROI', [hemisphere roiName], ...
                       'label', label);

  roiImage = extractRoiByLabel(sourceImage, labelStruct);

  entities = struct('space', 'MNI', ...
                    'hemi', hemisphere, ...
                    'desc', atlas, ...
                    'label', roiName);
  nameStructure = struct('entities', entities, ...
                         'suffix', 'mask', ...
                         'ext', '.nii');

  nameStructure.use_schema = false;

  newName = bids.create_filename(nameStructure);

  movefile(roiImage, fullfile(roiDir, newName));

  roiImage = fullfile(roiDir, newName);

  json = bids.derivatives_json(roiImage);
  bids.util.jsonencode(json.filename, json.content);
end
