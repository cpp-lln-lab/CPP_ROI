% (C) Copyright 2021 CPP ROI developers

function reslicedImages = resliceRoiImages(referenceImage, imagesToCheck)

  % TODO
  % - allow option to binarize output?

  % check if files are in the same space
  % if not we reslice the ROI to have the same resolution as the data image
  sts = checkRoiOrientation(referenceImage, imagesToCheck);
  if sts == 1
    reslicedImages = imagesToCheck;

  else

    matlabbatch = {};
    matlabbatch = setBatchReslice(matlabbatch, referenceImage, imagesToCheck);
    spm_jobman('run', matlabbatch);

    basename = spm_file(imagesToCheck, 'basename');
    reslicedImages = spm_file(imagesToCheck, 'basename', ...
                              [spm_get_defaults('realign.write.prefix') basename]);

  end

end

function matlabbatch = setBatchReslice(matlabbatch, referenceImg, sourceImages)

  interp = 1;
  write.roptions.interp = interp;

  if ischar(referenceImg)
    referenceImg = {referenceImg};
  end
  write.ref(1) = referenceImg;

  if ischar(sourceImages)
    sourceImages = {sourceImages};
  end
  write.source(1) = sourceImages;

  matlabbatch{end + 1}.spm.spatial.coreg.write = write;

end
