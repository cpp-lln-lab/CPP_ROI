function newName = renameFile(inputFile, specification)
  %
  % Renames a BIDS valid file into another BIDS valid file given some
  % specification.
  %
  % USAGE::
  %
  %   newName = renameFile(inputFile, specification)
  %
  % :param inputFile: better if fullfile path
  % :type inputFile: string
  % :param specification: structure specifying the details of the new name
  %                       The structure content must resemble that of the
  %                       output of bids.internal.parse_filename
  % :type specification: structure
  %
  % (C) Copyright 2021 CPP ROI developers

  specification.use_schema = false;
  newName = bids.create_filename(specification, inputFile);

  outputFile = spm_file(inputFile, 'filename', newName);

  movefile(inputFile, outputFile);

end
