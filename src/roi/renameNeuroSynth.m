function outputImage = renameNeuroSynth(inputImage)
  %
  % give a neurosynth map a name that is more bids friendly
  %
  % USAGE::
  %
  %   outputImage = renameNeuroSynth(inputImage)
  %
  % EXAMPLE::
  %
  %   inputImage = fullfile(pwd, 'motion_association-test_z_FDR_0.01.nii.gz');
  %   outputImage = renameNeuroSynth(inputImage);
  %
  %   outputImage
  %   >>
  %     fullfile(pwd, 'space-MNI_label-neurosynthMotion_probseg.nii.gz');
  %
  %
  % (C) Copyright 2021 CPP ROI developers

  p.filename = spm_file(inputImage, 'filename');
  p.suffix = 'probseg';
  p.ext = '.nii';
  if strcmp(spm_file(inputImage, 'ext'), 'gz')
    p.ext = [p.ext '.gz'];
  end
  % TODO: find the actual MNI space neurosynth images are in
  p.entities.space = 'MNI';

  basename = spm_file(inputImage, 'basename');
  parts = strsplit(basename, '_');
  p.entities.label = ['neurosynth ' parts{1}];

  bidsFile = bids.File(p);

  outputImage = spm_file(inputImage, 'filename', bidsFile.filename);

  movefile(inputImage, outputImage);

end
