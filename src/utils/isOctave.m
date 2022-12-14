function retval = isOctave()
  %
  % Returns true if the environment is Octave.
  %
  % USAGE::
  %
  %   retval = isOctave()
  %
  % :returns: :retval: (boolean)
  %

  % (C) Copyright 2022 CPP ROI developers

  persistent cacheval   % speeds up repeated calls

  if isempty (cacheval)
    cacheval = (exist ('OCTAVE_VERSION', 'builtin') > 0);
  end

  retval = cacheval;
end
