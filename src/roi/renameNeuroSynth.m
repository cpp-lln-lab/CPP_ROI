function newImage = renameNeuroSynth(image)
    
    basename = spm_file(image, 'basename');
    parts = strsplit(basename,'_');

    label = converToValidCamelCase(['neurosynth ' parts{1}]);
    newImage = spm_file(image, 'basename', ['space-MNI_label-' label '_probseg']); 
    
    movefile(image, newImage)
    
end