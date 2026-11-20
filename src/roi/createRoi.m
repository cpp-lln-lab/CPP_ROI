function [mask, outputFile] = createRoi(varargin)
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
  %
  % :param volumeDefiningImage: fullpath of the image that will define the space
  %                             (resolution, ...) if the ROI is to be saved.
  % :type volumeDefiningImage: string
  %
  % :param saveImg: Will save the resulting image as binary mask if set to
  %                 ``true``
  % :type saveImg: boolean
  %
  % :param specification: depending on the chosen ``type`` this can be:
  %
  %   :roiImage: - :string: fullpath of the roi image for ``'mask'``
  %
  %   :sphere: - :structure: defines the characteristic for ``'sphere'``
  %                          - ``sphere.location``: X Y Z coordinates in millimeters
  %                          - ``spehere.radius``: radius in millimeters
  %
  %   :specification: - :structure: defines the characteristic for ``'intersection'`` and ``'expand'``
  %                                 - ``sphere.location``: X Y Z coordinates in millimeters
  %                                 - ``sphere.radius``: radius in millimeters
  %
  %
  % :returns:
  %
  %      :mask: - :structure: the volume of interest adapted from ``spm_ROI``
  %
  %      - ``mask.def``:    VOI definition [sphere, mask]
  %      - ``mask.rej``:    cell array of disabled VOI definition options
  %      - ``mask.xyz`` :   centre of VOI {mm} (for sphere)
  %      - ``mask.spec``:   VOI definition parameters (radius for sphere)
  %      - ``mask.str`` :   description of the VOI
  %      - ``mask.descrip``
  %      - ``mask.label``
  %      - ``mask.roi``
  %
  %        - ``mask.roi.size``:   number of voxel in ROI
  %        - ``mask.roi.XYZ`` :   voxel coordinates
  %        - ``mask.roi.XYZmm`` : voxel world coordinates
  %
  %      - ``mask.global``
  %
  %        - ``mask.global.hdr`` : header of the "search space" where the roi is defined
  %        - ``mask.global.img``
  %        - ``mask.global.XYZ``
  %        - ``mask.global.XYZmm``
  %
  %

  % (C) Copyright 2021 CPP ROI developers

  args = inputParser;

  allowedTypes = @(x) ismember(x, {'mask', 'sphere', 'intersection', 'expand'});

  args.addRequired('type', allowedTypes);
  args.addRequired('specification');
  args.addOptional('volumeDefiningImage', '', @ischar);
  args.addOptional('outputDir', pwd, @isdir);
  args.addOptional('saveImg', false, @islogical);

  args.parse(varargin{:});

  type = args.Results.type;
  specification = args.Results.specification;
  volumeDefiningImage = args.Results.volumeDefiningImage;
  outputDir = args.Results.outputDir;
  saveImg = args.Results.saveImg;

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

      isBinaryMask(roiImage);

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

      isBinaryMask(roiImage);

      mask = createRoi('mask', roiImage);
      mask2 = createRoi('sphere', sphere);

      locationsToSample = mask.global.XYZmm;

      [~, mask.roi.XYZmm] = spm_ROI(mask2, locationsToSample);

      mask = setRoiSizeAndType(mask, type);

      mask = createRoiLabel(mask);

    case 'merge'

      roiImages = specification;
      
      mask = [];
                  
      % loop through the ROIs to merge
      for iRoi = 1:length(roiImages)
          
        % load one ROI per time
        maskToMerge = spm_read_vols(spm_vol(roiImages{iRoi}));
        
        mask = cat(4, mask, maskToMerge);
        
      end
      
      % merge the logical masks into one
      mask = any(mask, 4);
      
      % assign fileprefix (name to be save?) 
      % [ WIP ]
      % mask = createRoiLabel(mask);
      
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

      isBinaryMask(roiImage);

      % check that input image has at least enough voxels to include
      maskVol = spm_read_vols(spm_vol(roiImage));
      totalNbVoxels = sum(maskVol(:));
      if sphere.maxNbVoxels > totalNbVoxels
        error('Number of voxels requested greater than the total number of voxels in this mask');
      end

      specification  = struct('mask1', roiImage, ...
                              'mask2', sphere);

      % take as radius step the smallest voxel dimension of the roi image
      hdr = spm_vol(roiImage);
      dim = diag(hdr.mat);
      radiusStep = min(abs(dim(1:3)));

      % determine maximum radius to expand to
      maxRadius = hdr.dim .* dim(1:3)';
      maxRadius = max(abs(maxRadius));

      fprintf(1, '\n Expansion:');

      while  true
        mask = createRoi('intersection', specification);
        mask.roi.radius = specification.mask2.radius;

        fprintf(1, '\n radius: %0.2f mm; roi size: %i voxels', ...
                mask.roi.radius, ...
                mask.roi.size);

        if mask.roi.size > sphere.maxNbVoxels
          break
        end

        if mask.roi.radius > maxRadius
          error('sphere expanded beyond the dimension of the mask.');
        end

        specification.mask2.radius = specification.mask2.radius + radiusStep;
      end

      fprintf(1, '\n');

      mask.xyz = sphere.location;

      mask = setRoiSizeAndType(mask, type);

      mask = createRoiLabel(mask);

  end

  outputFile = [];
  if saveImg
    outputFile = saveRoi(mask, volumeDefiningImage, outputDir);
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

function outputFile = saveRoi(mask, volumeDefiningImage, outputDir)

  hdr = spm_vol(volumeDefiningImage);
  if numel(hdr) > 1
    err.identifier =  'createRoi:not3DImage';
    err.message = sprintf(['the volumeDefininigImage:', ...
                           '\n\t%s\n', ...
                           'must be a 3D image. It seems to be 4D image with %i volume.'], ...
                          image, numel(hdr));
    error(err);
  end

  if ~strcmp(mask.def, 'sphere') && ...
      exist(mask.spec, 'file') == 2 && ...
      strcmp(spm_file(mask.spec, 'ext'), 'nii')
    checkRoiOrientation(volumeDefiningImage, mask.spec);
  end

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
  outputFile = fullfile(outputDir, roiName);
  save_as_image(roiObject, outputFile);

  json = bids.derivatives_json(outputFile);
  bids.util.jsonencode(json.filename, json.content);

end
