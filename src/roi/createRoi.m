% (C) Copyright 2021 CPP ROI developers

function mask = createRoi(type, specification, volumeDefiningImage, outputDir, saveImg)
  %
  % Returns a mask to be used as a ROI by ``spm_summarize``.
  % Can also save the ROI as binary image.
  %
  % USAGE::
  %
  %   mask = createROI(type, ...
  %                   specification, ...
  %                   volumeDefiningImage = '', ...
  %                   outputDir = pwd, ...
  %                   saveImg = false);
  %
  %   mask = createROI('mask', roiImage);
  %   mask = createROI('sphere', sphere);
  %   mask = createROI('intersection', specification);
  %   mask = createROI('expand', specification);
  %
  % See the ``demos/roi`` to see examples on how to use it.
  %
  % :param type: ``'mask'``, ``'sphere'``, ``'intersection'``, ``'expand'``
  % :type type: string
  % :param specification: depending on the chosen ``type`` this can be:
  %
  %         :param roiImage: fullpath of the roi image for ``'mask'``
  %         :type roiImage: string
  %         :param sphere: defines the charateristic for ``'sphere'``
  %         :type sphere: structure
  %                ``sphere.location``: X Y Z coordinates in millimeters
  %                ``sphere.radius``: radius in millimeters
  %         :param specification: defines the charateristic for ``'intersection'`` and ``'expand'``
  %         :type sphere: structure
  %                ``sphere.location``: X Y Z coordinates in millimeters
  %                ``sphere.radius``: radius in millimeters
  %
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
  %
  %      mask.descrip
  %      mask.label
  %
  %      mask.roi.size      - number of voxel in ROI
  %      mask.roi.XYZ       - voxel coordinates
  %      mask.roi.XYZmm     - voxel world coordinates
  %
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

      mask = createRoiLabel(mask);

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

      mask = createRoiLabel(mask);

    case 'merge'

      roiImages = specification;
            
      % loop through the ROIs to merge
      for iRoi = 1:length(roiImages)
        % load one ROI per time
        maskToMerge = load_untouch_nii(roiImages{iRoi});
        % take the first ROI as reference to add the others to it
        if iRoi == 1
            mask = maskToMerge;
            % delete the fileprefix argument to be re-assigned with the new one
            mask.fileprefix = [];
        else 
            % sum up the ROI masks
            mask = mask.img + maskToMerge.img;
        end

      end
      
      % check that there are no 2s
      
      % assign fileprefix (name to be save?)
      
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

      mask = createRoiLabel(mask);

  end

  if saveImg
    saveRoi(mask, volumeDefiningImage, outputDir);
  end

end

function mask = defineGlobalSearchSpace(mask, image)
  %
  % gets the X, Y, Z subscripts of the voxels included in the ROI
  %

  mask.global.hdr = spm_vol(image);
  mask.global.img = logical(spm_read_vols(mask.global.hdr));

  [X, Y, Z] = ind2sub(size(mask.global.img), find(mask.global.img));

  % XYZ format
  mask.global.XYZ = [X'; Y'; Z'];
  mask.global.size = size(mask.global.XYZ, 2);

end

function XYZmm = returnXYZm(transformationMatrix, XYZ)
  %
  % apply voxel to world transformation
  %

  XYZmm = transformationMatrix(1:3, :) * [XYZ; ones(1, size(XYZ, 2))];
end

function mask = setRoiSizeAndType(mask, type)
  mask.def = type;
  mask.roi.size = size(mask.roi.XYZmm, 2);
end

function mask = createRoiLabel(mask)

  switch mask.def

    case 'sphere'

      mask.label = sprintf('sphere%0.0fx%0.0fy%0.0fz%0.0f', ...
                           mask.spec, ...
                           mask.xyz);

      % change any minus coordinate (x = -67) to minus (xMinus67)
      % SUPER ugly but any minus will mess up the bids parsing otherwise
      mask.label = strrep(mask.label, '-', 'Minus');

      mask.descrip = sprintf('%s at [%0.1f %0.1f %0.1f]', ...
                             mask.str, ...
                             mask.xyz);

    case 'expand'

      mask.label = sprintf('%sVox%i', ...
                           mask.def, ...
                           mask.roi.size);

      mask.descrip = sprintf('%s from [%0.0f %0.0f %0.0f] till %i voxels', ...
                             mask.def, ...
                             mask.xyz, ...
                             mask.roi.size);

    otherwise

      mask.label = mask.def;
      mask.descrip = mask.def;

  end

end

function saveRoi(mask, volumeDefiningImage, outputDir)

  if strcmp(mask.def, 'sphere')

    [~, mask.roi.XYZmm] = spm_ROI(mask, volumeDefiningImage);
    mask = setRoiSizeAndType(mask, mask.def);

  end

  roiName = createRoiName(mask, volumeDefiningImage);

  % use the marsbar toolbox
  roiObject = maroi_pointlist(struct('XYZ', mask.roi.XYZmm, ...
                                     'mat', spm_get_space(volumeDefiningImage), ...
                                     'label', mask.label, ...
                                     'descrip', mask.descrip));

  % use Marsbar to save as a .mat and then convert that to an image
  % in the correct space
  tempFile = spm_file(roiName, ...
                      'ext', ...
                      'mat');
  saveroi(roiObject, ...
          fullfile(outputDir, tempFile));
  mars_rois2img(fullfile(outputDir, tempFile), ...
                fullfile(outputDir, roiName), ...
                spm_vol(volumeDefiningImage));
  delete(fullfile(outputDir, tempFile));

  % delete label files
  delete(fullfile(outputDir, '*_mask_labels.mat'));

end

function roiName = createRoiName(mask, volumeDefiningImage)

  if strcmp(mask.def, 'sphere')

    p.filename = '';
    p.ext = '.nii';
    p.type = 'mask';

    if ~isempty(volumeDefiningImage)
      tmp = bids.internal.parse_filename(volumeDefiningImage);

      % if the volume defining image has a space entity we reuse it
      if isfield(p, 'space')
        p.space = tmp.space;
      end

    end

  else

    p = bids.internal.parse_filename(mask.global.hdr.fname);

  end

  label = '';
  if isfield(p, 'label')
    label = p.label;
  end

  p.label = [label ' ' mask.label];

  roiName = createFilename(p);

end
