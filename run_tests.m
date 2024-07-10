% (C) Copyright 2019 CPP ROI developers

warning('OFF');

spm('defaults', 'fMRI');

thisDir = fileparts(mfilename('fullpath'));

folderToCover = fullfile(thisDir, 'src');

testFolder = fullfile(thisDir, 'tests');

addpath(genpath(folderToCover));

addpath(fullfile(testFolder, 'utils'));
addpath(fullfile(thisDir, 'atlas'));

if isdir(fullfile(thisDir, 'lib', 'bids-matlab'))
  addpath(fullfile(thisDir, 'lib', 'bids-matlab'));
end

success = moxunit_runtests(testFolder, ...
                           '-verbose', '-recursive', '-randomize_order', ...
                           '-with_coverage', ...
                           '-cover', folderToCover, ...
                           '-cover_xml_file', 'coverage.xml', ...
                           '-cover_html_dir', fullfile(thisDir, 'coverage_html'));

exit(double(~success));
