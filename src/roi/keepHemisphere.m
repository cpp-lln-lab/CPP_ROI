% (C) Copyright 2021 CPP ROI developers

function image = keepHemisphere(image, hemisphere)
    %
    % Only keep the values from one hemisphere. Sets the other half to NaN.
    % Writes an image with an extra entity ``_hs-[hemisphere]``
    %
    % USAGE::
    %
    %   keepHemisphere(image, hemisphere)
    %
      % :param image: 
      % :type image: string
      % :param hemisphere: ``'lh'`` or ``'rh'``
      % :type hemisphere: string
      %

    hdr = spm_vol(image);
    vol = spm_read_vols(hdr);
    
    xDim = hdr.dim(1);
    xMid = round(xDim/2);
    
    switch lower(hemisphere)
        
        case 'lh'
            discard = 1:xMid;
            
        case 'rh'
             discard = xMid:xDim;
    end
    
    vol(discard,:,:) = NaN;
    
    p = bids.internal.parse_filename(image);
    p.hs = lower(hemisphere);
    newName = createFilename(p);
    
    hdr.fname = spm_file(image, 'filename', newName);

    spm_write_vol(hdr, vol);
    
    image = hdr.fname;
    
end