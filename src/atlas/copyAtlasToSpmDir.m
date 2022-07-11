function copyAtlasToSpmDir(atlas)
  %
  % copies a given atlas to the SPM atlas dir
  %
  % USAGE::
  %
  %   copyAtlasToSpmDir(atlas)
  %
  % :param atlas: Any of ``{'AAL'}``. Defaults to ``'AAL'``
  % :type  atlas: char
  %
  % (C) Copyright 2022 CPP_SPM developers
  
  if nargin < 1
    atlas = 'AAL';
  end
  
  spmAtlasDir = fullfile(spm('dir'), 'atlas');
  cppRoiAtlasDir = returnAtlasDir();
  
  switch lower(atlas)
    
    case 'aal'
      sourceAtlasImage = fullfile(cppRoiAtlasDir, 'AAL3', 'AAL3v1_1mm.nii.gz');
      sourceAtlasXml = fullfile(cppRoiAtlasDir, 'AAL3', 'AAL3v1_1mm.xml');
  end
  
  targetAtlasImage = fullfile(spmAtlasDir, spm_file(sourceAtlasImage, 'filename'));
  targetAtlasXml = fullfile(spmAtlasDir, spm_file(sourceAtlasXml, 'filename'));
  
  atlasPresent = isdir(spmAtlasDir) && ...
                 exist(targetAtlasImage(1:end-3), 'file') && ...
                 exist(targetAtlasXml, 'file');
  
  if ~atlasPresent
    fprintf('\nCopying atlas "%s" to spm atlas directory:\n\t%s\n', ...
            atlas, ...
            spmAtlasDir)
    spm_mkdir(spmAtlasDir);
    
    copyfile(sourceAtlasImage, spmAtlasDir);
    gunzip(fullfile(spmAtlasDir, '*.nii.gz'))
    delete(fullfile(spmAtlasDir, '*.nii.gz'))
    
    copyfile(sourceAtlasXml, spmAtlasDir);
    
  else
    fprintf('\nAtlas "%s" already in spm atlas directory:\n\t%s\n', ...
      atlas, ...
      spmAtlasDir)
    
  end
  
end