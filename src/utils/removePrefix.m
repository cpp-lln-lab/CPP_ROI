function image = removePrefix(image, prefix)
  %

  % (C) Copyright 2019 CPP ROI developers

  basename = spm_file(image, 'basename');
  tmp = spm_file(image, 'basename', basename(length(prefix) + 1:end));
  movefile(image, tmp);
  image = tmp;

end
