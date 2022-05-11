% (C) Copyright 2019 CPP ROI developers

% Does not work due to some relative path of the data when testing

warning('OFF');

spm('defaults', 'fMRI');

testFolder = fullfile(fileparts(mfilename('fullpath')), 'tests');

addpath(fullfile(testFolder, 'utils'));

folderToCover = fullfile(testFolder, '..', 'src');

success = moxunit_runtests( ...
                           testFolder, ...
                           '-verbose', '-recursive', '-with_coverage', ...
                           '-cover', folderToCover, ...
                           '-cover_xml_file', 'coverage.xml', ...
                           '-cover_html_dir', fullfile(pwd, 'coverage_html'));

if success
  system('echo 0 > test_report.log');
else
  system('echo 1 > test_report.log');
end
