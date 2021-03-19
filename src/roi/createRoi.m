% (C) Copyright 2021 CPP ROI developers

function mask = createRoi(type, specification, volumeDefiningImage, outputDir, saveImg)
  %
  % Returns a mask to be used as a ROI by ``spm_summarize``.
  % Can also save the ROI as binary image.
  %
  % USAGE::
  %
  %  mask = createROI(type, ...
  %                   specification, ...
  %                   volumeDefiningImage = '', ...
  %                   outputDir = pwd, ...
  %                   saveImg = false);
  %
  %  mask = createROI('mask', roiImage);
  %  mask = createROI('sphere', sphere);
  %  mask = createROI('intersection', specification);
  %  mask = createROI('expand', specification);
  %
  %
  % See the ``demos/roi`` to see examples on how to use it.
  %
  % :param type: ``'mask'``, ``'sphere'``, ``'intersection'``, ``'expand'``
  % :type type: string
  % :param roiImage: fullpath of the roi image
  % :type roiImage: string
  % :param sphere:
  %                ``sphere.location``: X Y Z coordinates in millimeters
  %                ``sphere.radius``: radius in millimeters
  % :type sphere: structure
  % :param volumeDefiningImage: fullpath of the image that will define the space
  %                             (resolution, ...) if the ROI is to be saved.
  % :type volumeDefiningImage: string
  % :param saveImg: Will save the resulting image as binary mask if set to
  %                 ``true``
  % :type saveImg: boolean
  %
  % :returns:
  %
  %      mask   - structure for the volume of interest adapted from ``spm_ROI``
  %
  %      mask.def           - VOI definition [sphere, mask]
  %      mask.rej           - cell array of disabled VOI definition options
  %      mask.xyz           - centre of VOI {mm} (for sphere)
  %      mask.spec          - VOI definition parameters (radius for sphere)
  %      mask.str           - description of the VOI
  %      mask.roi.size      - number of voxel in ROI
  %      mask.roi.XYZ       - voxel coordinates
  %      mask.roi.XYZmm     - voxel world coordinates
  %      mask.global.hdr    - header of the "search space" where the roi is
  %                           defined
  %      mask.global.img
  %      mask.global.XYZ
  %      mask.global.XYZmm
  %
  %

  if nargin < 5
    saveImg = false;
  end

  if nargin < 4
    outputDir = pwd;
  end

  if nargin < 3
    volumeDefiningImage = '';
  end

  switch type

    case 'sphere'

      sphere = specification;

      mask.def = type;
      mask.spec = sphere.radius;
      mask.xyz = sphere.location;

      if size(mask.xyz, 1) ~= 3
        mask.xyz = mask.xyz';
      end

      mask = spm_ROI(mask);
      mask.roi.XYZmm = [];

      mask = createRoiLabel(mask);

    case 'mask'

      roiImage = specification;

      mask = struct('XYZmm', []);
      mask = defineGlobalSearchSpace(mask, roiImage);

      % in real world coordinates
      mask.global.XYZmm = returnXYZm(mask.global.hdr.mat, mask.global.XYZ);

      assert(size(mask.global.XYZmm, 2) == sum(mask.global.img(:)));

      locationsToSample = mask.global.XYZmm;

      mask.def = type;
      mask.spec = roiImage;
      [~, mask.roi.XYZmm, j] = spm_ROI(mask, locationsToSample);

      mask.roi.XYZ = mask.global.XYZ(:, j);

      mask = setRoiSizeAndType(mask, type);

      mask = createRoiLabel(mask, roiImage);

    case 'intersection'

      % Ugly hack
      % ideally we want to loop over the masks and figure out
      % if they are binary images or spheres...
      if ischar(specification.mask1)
        roiImage = specification.mask1;
        sphere = specification.mask2;
      else
        roiImage = specification.mask1;
        sphere = specification.mask2;
      end

      mask = createRoi('mask', roiImage);
      mask2 = createRoi('sphere', sphere);

      locationsToSample = mask.global.XYZmm;

      [~, mask.roi.XYZmm] = spm_ROI(mask2, locationsToSample);

      mask = setRoiSizeAndType(mask, type);

      mask = createRoiLabel(mask, roiImage);

    case 'expand'

      % Ugly hack
      % ideally we want to loop over the masks and figure out
      % if they are binary images or spheres...
      if ischar(specification.mask1)
        roiImage = specification.mask1;
        sphere = specification.mask2;
      else
        roiImage = specification.mask1;
        sphere = specification.mask2;
      end

      specification  = struct( ...
                              'mask1', roiImage, ...
                              'mask2', sphere);

      % take as radius step the smallest voxel dimension of the roi image
      hdr = spm_vol(roiImage);
      dim = diag(hdr.mat);
      radiusStep = min(abs(dim(1:3)));

      while  true
        mask = createRoi('intersection', specification);
        mask.roi.radius = specification.mask2.radius;
        if mask.roi.size > sphere.maxNbVoxels
          break
        end
        specification.mask2.radius = specification.mask2.radius + radiusStep;
      end

      mask.xyz = sphere.location;

      mask = setRoiSizeAndType(mask, type);

      mask = createRoiLabel(mask, roiImage);

  end

  if saveImg
    saveRoi(mask, volumeDefiningImage, outputDir);
  end

end

function mask = defineGlobalSearchSpace(mask, image)

  mask.global.hdr = spm_vol(image);
  mask.global.img = logical(spm_read_vols(mask.global.hdr));

  [X, Y, Z] = ind2sub(size(mask.global.img), find(mask.global.img));

  % XYZ format
  mask.global.XYZ = [X'; Y'; Z'];
  mask.global.size = size(mask.global.XYZ, 2);

end

function XYZmm = returnXYZm(transformationMatrix, XYZ)
  % "voxel to world transformation"
  XYZmm = transformationMatrix(1:3, :) * [XYZ; ones(1, size(XYZ, 2))];
end

function mask = setRoiSizeAndType(mask, type)
  mask.def = type;
  mask.roi.size = size(mask.roi.XYZmm, 2);
end

function mask = createRoiLabel(mask, roiImage)

  switch mask.def

    case 'sphere'
      mask.descrip = sprintf('%0.1fmm radius sphere at [%0.1f %0.1f %0.1f]', ...
                             mask.spec, ...
                             mask.xyz);
      mask.label = sprintf('label-sphere%0.0fmmx%0.0fy%0.0fz%0.0f', ...
                           mask.spec, ...
                           mask.xyz);

    case 'expand'

      basename = spm_file(roiImage, 'basename');
      basename = strrep(basename, '_mask', '');
      mask.label = sprintf('%s_label-%sVox%i', ...
                           basename, ...
                           mask.def, ...
                           mask.roi.size);

      mask.descrip = sprintf('%s from [%0.0f %0.0f %0.0f] till %i voxels', ...
                             mask.def, ...
                             mask.xyz, ...
                             mask.roi.size);

    otherwise

      basename = spm_file(roiImage, 'basename');
      basename = strrep(basename, '_mask', '');
      mask.label = [basename '_label-' mask.def];

      mask.descrip = mask.def;

  end

end

function saveRoi(mask, volumeDefiningImage, outputDir)

  if strcmp(mask.def, 'sphere')
    [~, mask.roi.XYZmm] = spm_ROI(mask, volumeDefiningImage);
    mask = setRoiSizeAndType(mask, mask.def);
  end

  % use the marsbar toolbox
  roiObject = maroi_pointlist(struct('XYZ', mask.roi.XYZmm, ...
                                     'mat', spm_get_space(volumeDefiningImage), ...
                                     'label', mask.label, ...
                                     'descrip', mask.descrip));

  roiName = sprintf('%s_mask.nii', mask.label);
  save_as_image(roiObject, fullfile(outputDir, roiName));

end
