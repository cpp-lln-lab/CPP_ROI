% (C) Copyright 2021 CPP ROI developers

function newName = createFilename(p)

  entities = fieldnames(p);

  newName = '';
  for iEntity = 1:numel(entities)

    thisEntity = entities{iEntity};

    if ~any(strcmp(thisEntity, {'filename', 'type', 'ext'})) && ...
            ~isempty(p.(thisEntity))
      thisLabel = converToValidCamelCase(p.(thisEntity));
      newName = [newName '_' thisEntity '-' thisLabel]; %#ok<AGROW>
    end

  end

  % remove lead '_'
  newName(1) = [];

  ext = p.ext;
  suffix = p.type;
  newName = [newName '_', suffix ext];

end
