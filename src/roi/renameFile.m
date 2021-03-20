function image = renameFile(image, specification)
    
    pth = spm_fileparts(image);
    p = bids.internal.parse_filename(image);
    
    entitiesToChange = fieldnames(specification);
    
    for iEntity = 1:numel(entitiesToChange)
        p.(entitiesToChange{iEntity}) = specification.(entitiesToChange{iEntity});
    end
    
    newName = createFilename(p);
    
    movefile(image, fullfile(pth, newName));
    
end





