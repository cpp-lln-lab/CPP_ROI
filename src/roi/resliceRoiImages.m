% (C) Copyright 2021 CPP BIDS SPM-pipeline developers

function reslicedImages = resliceRoiImages(referenceImage, imagesToCheck)

  % TODO
  % - allow option to binarize output?

  % check if files are in the same space
  % if not we reslice the ROI to have the same resolution as the data image
  sts = checkRoiOrientation(referenceImage, imagesToCheck);
  if sts == 1
    reslicedImages = imagesToCheck;

  else
    
    matlabbatch = [];
    matlabbatch = setBatchReslice(matlabbatch, referenceImage, imagesToCheck);
    spm_jobman('run', matlabbatch);

    basename = spm_file(imagesToCheck, 'basename');
    reslicedImages = spm_file(imagesToCheck, 'basename', ...
        [spm_get_defaults('realign.write.prefix') basename]);

  end

end
