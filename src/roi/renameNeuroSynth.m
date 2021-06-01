function outputImage = renameNeuroSynth(inputImage)
  % give the neurosynth map a name that is more bids friendly
  %
  % space-MNI_label-neurosynthKeyWordsUsed_probseg.nii
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  p.filename = spm_file(inputImage, 'filename');
  p.suffix = 'probseg';
  p.ext = '.nii';
  p.entities.space = 'MNI';

  basename = spm_file(inputImage, 'basename');
  parts = strsplit(basename, '_');
  p.entities.label = ['neurosynth ' parts{1}];

  p.use_schema = false;

  newName = bids.create_filename(p);

  outputImage = spm_file(inputImage, 'filename', newName);

  movefile(inputImage, outputImage);

end
