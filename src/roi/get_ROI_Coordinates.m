function mni = get_ROI_Coordinates
  % This function gets the individual subject coordniates of the highest peak
  % within a specified Region of interest (usually coming from the group level univariate analysis)

  % Critical t-value for each experimental condition or mask file
  CriticalTs = 1;               % Critical t-value for visual condition in L-V5 and R-V5 and bilateral PT

  %% load the data structure
  WD = pwd;

  %% group of subjects to analyze
  opt.groups = {'EB', 'SCa', 'SCv'};      % {'EB','SCa','SCv'};
  % suject to run in each group
  opt.subjects = {[1:13], [1:10], [1:6]}; % {[1:13],[1:10],[1:6]};

  %%
  smoothing = '6';

  %% Regions that will be used to extract the highest t-value within that mask
  maskFn = {  'face_lFFA.nii'
            'face_rFFA.nii'
           };

  CriticalTs = ones(1, length(maskFn)) * CriticalTs;

  %% Location of the data
  data_path = '/Volumes/SanDisk/Oli_Data/Categs_BIDS/derivatives';

  % create an mni cell with dimensions (1x number of masks)
  mni = cell(1, length(maskFn));
  SubNames = {};

  % for each mask
  for iMask = 1:length(maskFn)

    fprintf('Running Mask %.0f \n\n', iMask);
    CriticalT = CriticalTs(iMask);           % get the critical t

    subCounter = 0;
    for iGroup = 1:length(opt.groups)
      for iSub = 1:length(opt.subjects{iGroup})

        fprintf('Running Subject %.0f \n', iSub);

        SubName = ['sub-', opt.groups{iGroup}, ...
                   sprintf('%02d', opt.subjects{iGroup}(iSub))];

        fprintf('%s \n', SubName);
        subCounter = subCounter + 1;
        SubNames{subCounter, iMask} = SubName(5:end);

        %% the first 4 masks are for the FACE condition, the other 4
        % are from the SCENE condition
        if iMask <= 2
          result_file = [data_path, '/', SubName, '/stats/ffx_visMotion/ffx_', smoothing, '/spmT_0013.nii']; % HUMAN > BIG_ENV
        else
          result_file = [data_path, '/', SubName, '/stats/ffx_audMotion/ffx_', smoothing, '/spmT_0014.nii']; % BIG_ENV > HUMAN
        end

        %%
        mask_path = fullfile(WD, 'Kanwisher_ROIs', maskFn{iMask});

        r = load_nii(result_file);
        m = load_nii(mask_path);

        r.img(~m.img) = nan;

        maxVal = max(r.img(:));
        maxVals(subCounter, iMask) = maxVal;

        if maxVal > CriticalT %|| maxVal < CriticalT

          % Get the location of the higest t-value in slice space
          voxel_idx = find(r.img == maxVal);

          disp(maxVal);
          [x, y, z] = ind2sub(size(r.img), voxel_idx);

          % convert space from slice number to mni
          mni{1, iMask}(subCounter, :) = cor2mni([x y z], mask_path);
          %               mni{1,iMask}(iSub,1) = mni{1,iMask}(iSub,1)* -1;   % If  masks created from AFNI or FSL,
          %               the x coordinate could be flipped (multiplied x -1). If this is the case, multiply x with -1.

          mni{1, iMask}(subCounter, :);

        else
          mni{1, iMask}(subCounter, 1:3) = nan;
        end

      end
    end
  end

  save('mni_coordinates.mat', 'mni', 'maskFn', 'opt', 'maxVals', 'SubNames');
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
  %       0     0     0     1];
  % end

  V = spm_vol(nifti_image);
  T = V.mat;

  cor = round(cor);
  mni = T * [cor(:, 1) cor(:, 2) cor(:, 3) ones(size(cor, 1), 1)]';
  mni = mni';
  mni(:, 4) = [];
end
