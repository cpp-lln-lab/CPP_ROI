function [sts, images] = checkRoiOrientation(referenceImage, imagesToCheck)
  %
  % USAGE::
  %
  %  [sts, images] = checkRoiOrientation(referenceImage, imagesToCheck)
  %
  % :param referenceImage: better if fullfile path
  % :type referenceImage: string
  % :param imagesToCheck: better if fullfile path
  % :type imagesToCheck: string
  %
  % (C) Copyright 2021 CPP ROI developers

  % TODO
  % - make it possible to pass several images in imagesToCheck at one

  images = char({referenceImage; imagesToCheck});

  % check if files are in the same space
  % if not we reslice the ROI to have the same resolution as the data image
  sts = spm_check_orientations(spm_vol(images));

end
