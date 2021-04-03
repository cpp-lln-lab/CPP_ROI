% (C) Copyright 2021 CPP ROI developers

function roiLabelLUT = getRoiLabelLookUpTable(atlas)

  if exist(atlas, 'file')
    roiLabelLUT = spm_load(atlas);
    return
  end

  atlasDir = returnAtlasDir(atlas);

  switch lower(atlas)

    case 'wang'

      roiLabelLUT = spm_load(fullfile(atlasDir, 'LUT.csv'));

    case 'anatomy_toobox'

      anat_tb_URL = 'https://www.fz-juelich.de/SharedDocs/Downloads/INM/INM-1/DE/Toolbox/Toolbox_22c.html';

      roiLabelLUT = fullfile(atlasDir, 'Anatomy_v22c_MPM.txt');

      if ~exist(roiLabelLUT, 'file')
        error('Did you install the spm Anatomy toolbox?\n\nDownload it from: %s', ...
              anat_tb_URL);
      end

      fid = fopen(roiLabelLUT);
      pattern = ['%s' repmat('%f', [1, 22])];
      C = textscan(fid, pattern, 'Headerlines', 1, 'Delimiter', '\t');
      fclose(fid);

      roiLabelLUT = struct('ROI', C(1), ...
                           'label', C(2));

  end

end
