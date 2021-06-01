function newName = renameFile(inputFile, specification)
  %
  % (C) Copyright 2021 CPP ROI developers

  specification.use_schema = false;
  newName = bids.create_filename(specification, inputFile);

  outputFile = spm_file(inputFile, 'filename', newName);

  movefile(inputFile, outputFile);

end
