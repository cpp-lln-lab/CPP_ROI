% (C) Copyright 2021 CPP ROI developers

function roiImage = extractRoiFromAtlas(roiDir, atlas, roiName, hemisphere)

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

  nameStructure = struct( ...
                         'space', 'MNI', ...
                         'hemi', hemisphere, ...
                         'desc', atlas, ...
                         'label', roiName, ...
                         'type', 'mask', ...
                         'ext', '.nii');
  newName = createFilename(nameStructure);

  movefile(roiImage, fullfile(roiDir, newName));

  roiImage = fullfile(roiDir, newName);
end
