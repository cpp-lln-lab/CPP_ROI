% This script will run through the ROIs made for each subject fo a ROI
% based anaylisis using MarsBar to get a time course of the activations and
% a percent signal change for each ROI and subject

clc;

if ~exist('machine_id', 'var')
  machine_id = 2; % 0: container ;  1: Remi ;  2: Beast
end

% 'MNI' or  'T1w' (native)
if ~exist('space', 'var')
  space = 'T1w';
end

if ~exist('randomize', 'var')
  randomize = 0;
end

% event specification for getting fitted event time-courses
contrast_idx = 1;
event_session_no = repmat(1:4, 1, 4);
event_type_no = repmat([1:4]', 1, 4)';
event_spec = [event_session_no; event_type_no(:)'];
event_duration = 16; % default SPM event duration

% FOR INFO
% contrast_ls = {
%     'Euc-Left + Alm-Left + Euc-Right + Alm-Right > 0'
%     'Euc-Left + Alm-Left + Euc-Right + Alm-Right < 0'
%     'Alm-Left + Alm-Right > 0'
%     'Alm-Left + Alm-Right < 0'
%     'Euc-Left + Euc-Right > 0'
%     'Euc-Left + Euc-Right < 0'
%     'Euc-Right + Alm-Right > 0'
%     'Euc-Right + Alm-Right < 0'
%     'Euc-Left + Alm-Left > 0'
%     'Euc-Left + Alm-Left < 0'
%     'Euc-Left > 0'
%     'Euc-Left < 0'
%     'Alm-Left > 0'
%     'Alm-Left < 0'
%     'Euc-Right > 0'
%     'Euc-Right < 0'
%     'Alm-Right > 0'
%     'Alm-Right < 0'
%     'resp-03 + resp-12 > 0'
%     'resp-03 + resp-12 < 0'};

%%
% setting up directories
[data_dir, code_dir, output_dir, fMRIprep_DIR] = set_dir(machine_id);

% Set up the SPM defaults, just in case
addpath(fullfile(spm('dir'), 'toolbox', 'marsbar'));
% Start marsbar to make sure spm_get works
marsbar('on');

% get data info
bids =  spm_BIDS(fullfile(data_dir, 'raw'));

% get subjects
folder_subj = get_subj_list(output_dir);
folder_subj = cellstr(char({folder_subj.name}')); % turn subject folders into a cellstr
[~, ~, folder_subj] = rm_subjects([], [], folder_subj, true);
nb_subjects = numel(folder_subj);
group_id = ~cellfun(@isempty, strfind(folder_subj, 'ctrl')); %#ok<*STRCLFH>

% see what GLM to run
opt = struct();
[sets] = get_cfg_GLMS_to_run();
[opt, all_GLMs] = set_all_GLMS(opt, sets);

if randomize
  shuffle_subjs = randperm(length(group_id));
end

%% for each subject

time_course = {};
percent_signal_change = {};

for i_subj = 1:nb_subjects

  fprintf('running %s\n', folder_subj{i_subj});

  subj_dir = fullfile(output_dir, [folder_subj{i_subj}]);

  roi_src_folder = fullfile(data_dir, 'derivatives', 'ANTs', folder_subj{i_subj}, 'roi');
  if strcmp(space, 'MNI')
    roi_src_folder = fullfile(code_dir, 'inputs');
  end

  roi_tgt_folder = fullfile(subj_dir, 'roi');
  mkdir(roi_tgt_folder);

  marsbar_save_folder = fullfile(output_dir, '..', 'marsbar', folder_subj{i_subj});
  mkdir(marsbar_save_folder);

  % list ROIs
  roi_ls =  spm_select('FPList', ...
                       roi_src_folder, ...
                       ['^ROI-.*_space-' space '.nii$']);
  roi_ls = cellstr(roi_ls);

  % go through all the models specified and get for each ROI the percetn
  % signal change and time course
  fprintf(' running GLMs\n');
  for i_GLM = 1:size(all_GLMs)

    cfg = get_configuration(all_GLMs, opt, i_GLM);

    cfg_list{i_GLM} = cfg;

    % directory for this specific analysis
    analysis_dir = name_analysis_dir(cfg, space);
    analysis_dir = fullfile ( ...
                             output_dir, ...
                             folder_subj{i_subj}, 'stats', analysis_dir);

    SPM = load(fullfile(analysis_dir, 'SPM.mat'));

    for i_roi = 1:size(roi_ls, 1)

      roi = roi_ls{i_roi};

      [path, file] = spm_fileparts(roi);

      img = spm_read_vols(spm_vol(roi));

      disp(sum(img(:) > 0));

      % create ROI object for Marsbar and convert to matrix format to avoid delicacies of image format
      roi_obj = maroi_image(struct('vol', spm_vol(roi), 'binarize', 1, ...
                                   'func', []));
      roi_obj = maroi_matrix(roi_obj);

      % give it a label
      label(roi_obj, strrep(file, 'ROI-', ''));
      saveroi(roi_obj, fullfile(roi_tgt_folder, [file '_roi.mat']));

      D = mardo(SPM);

      try

        % Extract data
        Y = get_marsy(roi_obj, D, 'mean');

        % MarsBaR estimation
        E = estimate(D, Y);

        % Get, store statistics
        stat_struct = compute_contrasts(E, contrast_idx);

        % And fitted time courses
        [tc, dt] = event_fitted(E, event_spec, event_duration);

        % Get percent signal change
        psc = event_signal(E, event_spec, event_duration, 'abs max');

        % Make fitted time course into ~% signal change
        block_means(E);
        tc = tc / mean(block_means(E)) * 100;

        % Store values
        time_course{i_roi, i_GLM}(i_subj, :) = tc; %#ok<SAGROW>
        percent_signal_change{i_GLM}(i_subj, i_roi) = psc;

        % sqve for this subject, ROI, GLM
        name_save_file = fullfile(marsbar_save_folder, ...
                                  [file '_' name_analysis_dir(cfg, space) '.mat']);
        save(name_save_file, 'tc', 'psc', 'cfg', 'file', 'dt');

      catch

        warning('\n\nSomething went wrong: %s - %s\n\n', ...
                folder_subj{i_subj}, file);

      end

    end
  end

  if randomize
    time_course{i_roi, i_GLM} = time_course{i_roi, i_GLM}(shuffle_subjs, :);
    percent_signal_change{i_GLM} = percent_signal_change{i_GLM}(shuffle_subjs);
  end

end
