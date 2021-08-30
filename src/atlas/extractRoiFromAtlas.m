function roiImage = extractRoiFromAtlas(roiDir, atlas, roiName, hemisphere)
  %
  % (C) Copyright 2021 CPP ROI developers

  if strcmp(atlas, 'wang')

    [maxProbaFiles, roiLabels] = getRetinoProbaAtlas();

    if strcmp(hemisphere, 'L')
      sourceImage = maxProbaFiles(1, :);
    else
      sourceImage = maxProbaFiles(2, :);
    end
    
  elseif   strcmp(atlas, 'neuromorphometrics')
      
      sourceImage = fullfile(returnAtlasDir(), 'space-IXI549Space_desc-neuromorphometrics_dseg.nii');
      
      roiLabels = getRoiLabelLookUpTable(atlas);
    
  end

  roiIdx = strcmp(roiName, roiLabels.ROI);
  label = roiLabels.label(roiIdx);

  labelStruct = struct('ROI', [hemisphere roiName], ...
                       'label', label);

  roiImage = extractRoiByLabel(sourceImage, labelStruct);

  entities = struct('space', 'MNI', ...
                    'hemi', hemisphere, ...
                    'label', roiName, ...
                    'desc', atlas);
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
