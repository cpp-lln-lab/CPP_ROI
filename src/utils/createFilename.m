function newName = createFilename(p)
    
    entities = fieldnames(p);
    ext = p.ext;
    suffix = p.type;
    
    % create a new file name based on the remaining entities in the order they
    % are in the structure
    entities = setxor(entities, {'filename', 'type', 'ext'}, 'stable');
    
    newName = '';
    for iEntity = 1:numel(entities)
        
        thisEntity = entities{iEntity};
        
        if ~isempty(p.(thisEntity))
            thisLabel = converToValidCamelCase(p.(thisEntity));
            newName = [newName '_' thisEntity '-' thisLabel]; %#ok<AGROW>
        end
        
    end
    
    % remove lead '_'
    newName(1) = [];
    
    newName = [newName '_', suffix ext];
    
end