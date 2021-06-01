function [maxProbaFiles, roiLabels] = getRetinoProbaAtlas()
  %
  % Loads the volumetric data from the
  % Probabilistic Maps of Visual Topography in Human Cortex
  %
  % maxProbaVol: 4D volume of ROIs in MNII space with
  %
  %              - left hemisphere as maxProbaVol(:,:,:,1)
  %              - right hemisphere as maxProbaVol(:,:,:,2)
  %
  %   DOI 10.1093/cercor/bhu277
  %   PMCID: PMC4585523
  %   PMID: 25452571
  %   Probabilistic Maps of Visual Topography in Human Cortex
  %
  % (C) Copyright 2021 CPP ROI developers

  unzipAtlas('wang');

  atlasDir = returnAtlasDir('wang');

  maxProbaFiles = spm_select('FPList', fullfile(atlasDir, 'subj_vol_all'), '^.*_dseg.nii$');

  roiLabels = getRoiLabelLookUpTable('wang');

end
