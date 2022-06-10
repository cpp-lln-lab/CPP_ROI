function test_suite = test_plotRoi %#ok<*STOUT>
  % (C) Copyright 2022 CPP ROI developers
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_test_plotDataInRoi_basic()

  close all;

  mask1 = createDummyMask(1);
  data1 = createDummyData(1);

  plotDataInRoi(data1, mask1);

  delete *.nii;

end

function test_test_plotDataInRoi_many_rois_and_data()

  mask1 = createDummyMask(1);
  mask2 = createDummyMask(2);
  mask3 = createDummyMask(3);
  mask4 = createDummyMask(4);
  data1 = createDummyData(1);
  data2 = createDummyData(2);
  data3 = createDummyData(3);
  data4 = createDummyData(4);

  mask = cellstr(cat(1, mask1, mask2, mask3, mask4));
  data = cellstr(cat(1, data1, data2, data3, data4));

  plotDataInRoi(data, mask);

  delete *.nii;

end

function test_test_plotDataInRoi_many_rois_as_cols_and_data()

  mask1 = createDummyMask(1);
  mask2 = createDummyMask(2);
  mask3 = createDummyMask(3);
  mask4 = createDummyMask(4);
  data1 = createDummyData(1);
  data2 = createDummyData(2);
  data3 = createDummyData(3);
  data4 = createDummyData(4);

  mask = cellstr(cat(1, mask1, mask2, mask3, mask4));
  data = cellstr(cat(1, data1, data2, data3, data4));

  plotDataInRoi(data, mask, 'roiAs', 'cols');

  delete *.nii;

end

function M = mat()
  M = ...
   [-3     0     0    84; ...
    0     3     0  -116; ...
    0     0     3   -56; ...
    0     0     0     1];

end

function mask = createDummyMask(idx)

  MIN = randi([1, 40 / 2], 1);
  MAX = randi([MIN + 5, 40], 1);

  maskHdr = struct( ...
                   'fname',   ['label-' num2str(idx) '_mask.nii'], ...
                   'dim',     [40, 40, 40], ...
                   'dt',      [spm_type('uint8') spm_platform('bigend')], ...
                   'mat',     mat(), ...
                   'pinfo',   [1 0 0]', ...
                   'descrip', 'mask');

  maskVol = false(40, 40, 40);
  maskVol(MIN:MAX, MIN:MAX, MIN:MAX) = true;

  spm_write_vol(maskHdr, maskVol);

  mask = fullfile(pwd, maskHdr.fname);

end

function data = createDummyData(idx)

  dataHdr = struct( ...
                   'fname',   ['label-' num2str(idx) '_beta.nii'], ...
                   'dim',     [40, 40, 40], ...
                   'dt',      [spm_type('float32') spm_platform('bigend')], ...
                   'mat',     mat(), ...
                   'pinfo',   [1 0 0]', ...
                   'descrip', 'data');

  dataVol = nan(40, 40, 40);
  dataVol(2:39, 2:39, 2:39) = zeros(38, 38, 38);
  dataVol(3:38, 3:38, 3:38) = randn() * 10 + randn(36, 36, 36) * 10;

  spm_write_vol(dataHdr, dataVol);

  data = fullfile(pwd, dataHdr.fname);

end
