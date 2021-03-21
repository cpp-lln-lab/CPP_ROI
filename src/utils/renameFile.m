function file = renameFile(file, specification)

  pth = spm_fileparts(file);
  p = bids.internal.parse_filename(file);

  entitiesToChange = fieldnames(specification);

  for iEntity = 1:numel(entitiesToChange)
    p.(entitiesToChange{iEntity}) = specification.(entitiesToChange{iEntity});
  end

  newName = createFilename(p);

  movefile(file, fullfile(pth, newName));

end
