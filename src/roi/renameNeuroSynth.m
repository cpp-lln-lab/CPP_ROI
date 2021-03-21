function newImage = renameNeuroSynth(image)
  % give the neurosynth map a name that is more bids friendly
  %
  % space-MNI_label-neurosynthKeyWordsUsed_probseg.nii
  %

    p.filename = spm_file(image, 'filename');
    p.type = 'probseg';
    p.ext= '.nii';
    p.space = 'MNI';
    
    basename = spm_file(image, 'basename');
    parts = strsplit(basename,'_');
    p.label = ['neurosynth ' parts{1}];
    
    newName = createFilename(p);
    
    newImage = spm_file(image, 'filename', newName); 
    
    movefile(image, newImage)
    
end