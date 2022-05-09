function newName = renameFile(inputFile, specification)
  %
  % Renames a BIDS valid file into another BIDS valid file given some
  % specificationification.
  %
  % USAGE::
  %
  %   newName = renameFile(inputFile, specificationification)
  %
  % :param inputFile: better if fullfile path
  % :type inputFile: string
  % :param specificationification: structure specificationifying the details of the new name
  %                       The structure content must resemble that of the
  %                       output of bids.internal.parse_filename
  % :type specificationification: structure
  %
  % (C) Copyright 2021 CPP ROI developers

  bf = bids.File(inputFile, 'use_schema', false);

  if isfield(specification, 'prefix')
    bf.suffix = specification.prefix;
  end
  if isfield(specification, 'suffix')
    bf.suffix = specification.suffix;
  end
  if isfield(specification, 'ext')
    bf.extension = specification.ext;
  end
  if isfield(specification, 'entities')
    entities = fieldnames(specification.entities);
    for i = 1:numel(entities)
      bf = bf.set_entity(entities{i}, ...
                         bids.internal.camel_case(specification.entities.(entities{i})));
    end
  end
  if isfield(specification, 'entity_order')
    bf = bf.reorder_entities(specification.entity_order);
  end

  bf = bf.update;

  newName = bf.filename;
  outputFile = spm_file(inputFile, 'filename', newName);

  movefile(inputFile, outputFile);

end
