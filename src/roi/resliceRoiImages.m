function [reslicedImages, matlabbatch] = resliceRoiImages(referenceImage, imagesToCheck, dryRun)
  %
  % Check if images are in the same orientation and reslice if necessarrry.
  %
  % USAGE::
  %
  %     reslicedImages = resliceRoiImages(referenceImage, imagesToCheck, dryRun)
  %
  % :param referenceImage:
  % :type referenceImage: path
  %
  % :param imagesToCheck:
  % :type imagesToCheck: path or cellstr
  %
  % :param dryRun: Only returns
  % :type dryRun: logical
  %
  % (C) Copyright 2021 CPP ROI developers

  % TODO
  % - allow option to binarize output?

  matlabbatch = {};
  reslicedImages = '';

  % check if files are in the same space
  % if not we reslice the ROI to have the same resolution as the data image
  sts = checkRoiOrientation(referenceImage, imagesToCheck);
  if sts == 1
    reslicedImages = imagesToCheck;

  else

    matlabbatch = setBatchReslice(matlabbatch, referenceImage, imagesToCheck);

    if ~dryRun
      spm_jobman('run', matlabbatch);
    end

    basename = spm_file(imagesToCheck, 'basename');
    reslicedImages = spm_file(imagesToCheck, 'basename', ...
                              [spm_get_defaults('realign.write.prefix') basename]);

  end

end

function matlabbatch = setBatchReslice(matlabbatch, referenceImg, sourceImages)

  interp = 4;
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
