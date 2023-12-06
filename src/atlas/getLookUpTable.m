function roiLabelLUT = getLookUpTable(atlasName)
  %
  % USAGE::
  %
  %   roiLabelLUT = getRoiLabelLookUpTable(atlas)
  %
  % :param atlas: fullpath of the look up table to load or name of the atlas
  %               whose UT you want
  % :type atlas:  string
  %
  % :returns: - :roiLabelLUT: a structure with the fields ``ROI`` and ``label``
  %

  % (C) Copyright 2021 CPP ROI developers

  if exist(atlasName, 'file')
    roiLabelLUT = spm_load(atlasName);
    return
  end

  atlasDir = returnAtlasDir(atlasName);

  isAKnownAtlas(atlasName);

  switch lower(atlasName)

    case {'wang', 'glasser'}

      unzipAtlas(lower(atlasName));

      roiLabelLUT = spm_load(fullfile(atlasDir, 'LUT.csv'));

    case 'neuromorphometrics'

      roiLabelLUT = spm_load(fullfile(returnAtlasDir(), ...
                                      'space-IXI549Space_desc-neuromorphometrics_dseg.csv'));
    case 'anatomy_toobox'

      anat_tb_URL = 'https://www.fz-juelich.de/SharedDocs/Downloads/INM/INM-1/DE/Toolbox/Toolbox_22c.html';

      roiLabelLUT = fullfile(atlasDir, 'Anatomy_v22c_MPM.txt');

      if ~exist(roiLabelLUT, 'file')
        error(['Could not find look up table: %s.\n'...
               'Did you install the spm Anatomy toolbox?\n\n', ...
               'Download it from: %s'], ...
              roiLabelLUT, ...
              anat_tb_URL);
      end

      fid = fopen(roiLabelLUT);
      pattern = ['%s' repmat('%f', [1, 22])];
      C = textscan(fid, pattern, 'Headerlines', 1, 'Delimiter', '\t');
      fclose(fid);

      roiLabelLUT = struct('ROI', C(1), ...
                           'label', C(2));

    case 'hcpex'

      roiLabelLUT = fullfile(atlasDir, 'HCPex.nii.txt');

      fid = fopen(roiLabelLUT);
      pattern = '%f%s%s%f';
      C = textscan(fid, pattern, 'Headerlines', 1);
      fclose(fid);

      for i = 1:numel(C{2})
        ROI{1}{i} = [C{2}{i} '_' C{3}{i}];
      end

      roiLabelLUT = struct('ROI', ROI(1), ...
                           'label', C(1));

    case 'visfatlas'

      unzipAtlas('visfAtlas');

      roiLabelLUT = spm_load(fullfile(atlasDir, 'LUT.csv'));

  end

end
