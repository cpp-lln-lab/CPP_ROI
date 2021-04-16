% (C) Copyright 2021 CPP ROI developers

function newName = createFilename(p)

  entities = fieldnames(p.entities);

  newName = '';
  for iEntity = 1:numel(entities)

    thisEntity = entities{iEntity};

    if ~isempty(p.entities.(thisEntity))
      thisLabel = convertToValidCamelCase(p.entities.(thisEntity));
      newName = [newName '_' thisEntity '-' thisLabel]; %#ok<AGROW>
    end

  end

  % remove lead '_'
  newName(1) = [];

  ext = p.ext;
  suffix = p.suffix;
  newName = [newName '_', suffix ext];

end
