% (C) Copyright 2021 CPP ROI developers

function test_suite = test_unit_convertToValidCamelCase %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_convertToValidCamelCaseBasic()

  str = 'foo bar';
  str = convertToValidCamelCase(str);
  assertEqual(str, 'fooBar');

  %% set up

  str = '&|@#-_(!{})01[]%+/=:;.?,\<> visual task';
  str = convertToValidCamelCase(str);
  assertEqual(str, '01VisualTask');

end
