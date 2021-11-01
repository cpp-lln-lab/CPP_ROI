% This script will run through the ROIs made for each subject fo a ROI
% based anaylisis using MarsBar to get a time course of the activations and
% a percent signal change for each ROI and subject

% TODO
% - refactor
% - what are the units of the time course?
% -  they do not match those of the percent signal change !!!!

clc;
clear;

if ~exist('machine_id', 'var')
  machine_id = 1; % 0: container ;  1: Remi ;  2: Beast
end

% 'MNI' or  'T1w' (native)
if ~exist('space', 'var')
  space = 'T1w';
end

if ~exist('randomize', 'var')
  randomize = 0;
end

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

% get data info
bids =  spm_BIDS(fullfile(data_dir, 'raw'));

% get subjects
marsbar_save_folder = fullfile(output_dir, '..', 'marsbar');
folder_subj = get_subj_list(marsbar_save_folder);
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

roi_ls = {
          'V1'
          'V2'
          'V3d'
          'V3v'
          'V4v'
          'V4d'
          'V5'
          'L-R-Primary-Olf-Cortex'
          'L-R-Secondary-Cortex'
          'L-R-Piri'
          'L-R-Orbitofrontal'
         };

%% for each subject

time_course = {};
percent_signal_change = {};

for i_subj = 1:nb_subjects

  fprintf('running %s\n', folder_subj{i_subj});

  subj_folder = fullfile(output_dir, '..', 'marsbar', folder_subj{i_subj});

  % go through all the models specified and get for each ROI the percetn
  % signal change and time course
  fprintf(' running GLMs\n');
  for i_GLM = 1:size(all_GLMs)

    cfg = get_configuration(all_GLMs, opt, i_GLM);

    for i_roi = 1:size(roi_ls, 1)

      roi_file =  spm_select('FPList', ...
                             subj_folder, ...
                             ['^ROI-' roi_ls{i_roi} ...
                              '.*_space-' space ...
                              '.*' name_analysis_dir(cfg, space)  ...
                              '.*.mat$']);

      psc = nan;
      tc = nan(855, 1);

      if ~isempty(roi_file)
        load(roi_file, 'tc', 'psc');
      end

      time_course{i_roi, i_GLM}(i_subj, :) = tc; %#ok<SAGROW>
      percent_signal_change{i_GLM}(i_subj, i_roi) = psc;

      clear psc tc;

    end
  end

end

%% Show fitted event time courses
opt = get_option(opt);
Colors = [ ...
          opt.blnd_color / 255; ...
          opt.sighted_color / 255];
Colors_desat = Colors + (1 - Colors) * (1 - .3);

black = [0 0 0];

close all;
figure;
hold on;

dt = 0.0561;
secs = [0:size(time_course{1}, 2) - 1] * dt;

for i_roi = 1:size(roi_ls, 1)

  figure('name', roi_ls{i_roi}, 'Position', [100 100 600 600]);
  hold on;

  for i_group = 0:1

    data = time_course{i_roi}(group_id == i_group, :);

    to_plot = nanmean(data);
    sem = nanstd(data) / size(data, 1)^.5;

    plot(secs, to_plot, 'color', Colors(i_group + 1, :), 'linewidth', 2);

  end

  plot(secs, zeros(size(secs)), '--k', 'linewidth', 1);

  for i_group = 0:1

    data = time_course{i_roi}(group_id == i_group, :);

    to_plot = nanmean(data);
    sem = nanstd(data) / size(data, 1)^.5;

    %         plot(secs, data, 'color', Colors_desat(i_group+1,:),
    %         'linewidth', .5);

    shadedErrorBar(secs, to_plot, sem, ...
                   {'color', Colors(i_group + 1, :), 'linewidth', 2}, 1);

  end

  legend({'blind', 'ctrl'});

  n_blind = sum(~isnan(percent_signal_change{i_GLM}(group_id == 0, i_roi)));
  n_ctrl = sum(~isnan(percent_signal_change{i_GLM}(group_id == 1, i_roi)));
  text(30, 0.07, sprintf('blind ; n = %i', n_blind));
  text(30, 0.05, sprintf('ctrl ; n = %i', n_ctrl));

  limit_axis = axis;
  axis([limit_axis(1:2) -0.13 0.13]);

  title(['Time courses for ' roi_ls{i_roi}], 'Interpreter', 'none');
  xlabel('Seconds');
  ylabel('% signal change');

  ax = gca;
  axPos = ax.Position;
  axPos(1) = axPos(1) + .5;
  axPos(2) = axPos(2) + .1;
  axPos(3) = axPos(3) * .3;
  axPos(4) = axPos(4) * .3;
  axes('Position', axPos);

  for i_group = 0:1

    to_plot = percent_signal_change{i_GLM}(group_id == i_group, i_roi);

    h = plotSpread(to_plot, 'distributionIdx', ones(size(to_plot)), ...
                   'distributionMarkers', {'o'}, ...
                   'distributionColors', Colors(i_group + 1, :), ...
                   'xValues', i_group + 1, ...
                   'showMM', 0, ...
                   'binWidth', .1, 'spreadWidth', 1);

    set(h{1}, 'MarkerSize', 5, 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', Colors(i_group + 1, :), ...
        'LineWidth', 2);

    h = errorbar(i_group + .5, ...
                 nanmean(to_plot), ...
                 nanstd(to_plot) / numel(to_plot)^.5, ...
                 'o', ...
                 'color', Colors(i_group + 1, :), 'linewidth', 1, ...
                 'MarkerSize', 5, ...
                 'MarkerEdgeColor', 'k', ...
                 'MarkerFaceColor', Colors(i_group + 1, :));

  end

  plot([0 3], [0 0], 'k');

  MAX = max(abs(percent_signal_change{i_GLM}(:, i_roi)));

  axis([0.2 2.5 -MAX MAX]);

  set(gca, 'fontsize', 8, ...
      'ytick', -1:0.25:1, 'yticklabel', -1:0.25:1, ...
      'xtick', 1:2, 'xticklabel', {'blind', 'ctrl'}, ...
      'ticklength', [.02 .02], 'tickdir', 'out');

end
