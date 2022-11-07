function [worldCoord, voxelCoord, maxVal] = getPeakCoordinates(varargin)
  %
  % This function gets the coordinates of a peak within a specified region of
  % interest.
  %
  % USAGE::
  %
  %     [worldCoord, voxelCoord, maxVal] = getPeakCoordinates(dataImage, roiImage, threshold)
  %
  % :param dataImage: data image (beta / t / Z map) to find the maximum in
  % :type dataImage: path
  %
  % :param roiImage: binary mask limiting the volume where to find the peak
  % :type roiImage: path
  %
  % :param threshold: threshold above which peak must be found
  % :type threshold: numerical
  %
  %

  % (C) Copyright 2021 CPP ROI developers

  % TODO
  % if no threshold is requested images do not need to be at the samre resolution

  isFile = @(x) exist(x, 'file') == 2;

  args = inputParser;

  args.addRequired('dataImage', isFile);
  args.addRequired('roiImage',  isFile);
  args.addOptional('threshold', 0, @isnumeric);

  args.parse(varargin{:});

  dataImage = args.Results.dataImage;
  roiImage = args.Results.roiImage;
  threshold = args.Results.threshold;

  voxelCoord = nan(1, 3);
  worldCoord = nan(1, 3);

  maxVal = spm_summarise(spm_vol(dataImage), roiImage, @max);

  if ~checkRoiOrientation(dataImage, roiImage)
    return
  end

  if maxVal < threshold
    warning('getPeakCoordinates:noMaxBeyondThreshold', ...
            'No max value found beyond threshold %f in image:\n %s\n', ...
            dataImage, ...
            threshold);
    return
  end

  data = spm_read_vols(spm_vol(dataImage));
  mask = spm_read_vols(spm_vol(roiImage));

  data(~mask) = nan(1, sum(~mask(:)));

  % Get the location of the highest t-value in slice space
  voxeIdx = find(data == maxVal);
  if numel(voxeIdx) > 1
    % TODO return list of all maximums?
    warning('getPeakCoordinates:severalMaxBeyondThreshold', ...
            'Several equal max value found beyond threshold %f in image:\n %s\n', ...
            dataImage, ...
            threshold);
    return
  end

  [x, y, z] = ind2sub(size(data), voxeIdx);
  voxelCoord = [x, y, z];

  % convert space from slice number to world coordinate
  worldCoord = cor2mni(voxelCoord, roiImage);

  % TODO
  %  world_coord(1) = world_coord(1) * -1;
  % If  masks created from AFNI or FSL,
  % the x coordinate could be flipped (multiplied x -1).
  % If this is the case, multiply x with -1.

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% cor2mni
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mni = cor2mni(cor, nifti_image)
  % function mni = cor2mni(cor, T)
  % convert matrix coordinate to mni coordinate
  %
  % cor: an Nx3 matrix
  % T: (optional) rotation matrix
  % mni is the returned coordinate in mni space
  %
  % caution: if T is not given, the default T is
  % T = ...
  %     [-4     0     0    84;...
  %      0     4     0  -116;...
  %      0     0     4   -56;...
  %      0     0     0     1];
  %
  % xu cui
  % 2004-8-18
  % last revised: 2005-04-30

  % if nargin == 1
  %     T = ...
  %         [-4     0     0    84;...
  %          0     4     0  -116;...
  %          0     0     4   -56;...
  %          0     0     0     1];
  % end

  V = spm_vol(nifti_image);
  T = V.mat;

  cor = round(cor);
  mni = T * [cor(:, 1) cor(:, 2) cor(:, 3) ones(size(cor, 1), 1)]';
  mni = mni';
  mni(:, 4) = [];
end
