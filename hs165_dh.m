function dh=hs165_dh(varargin)
% create HS150 DH table (angles are in degree)
% Usage: dh=puma_dh(options)
%    'perr' - position error magnitude (mm)  (i.e. 0.5mm)
%    'aerr' - angular error offset (degree)  (i.e. 0.2 degree)

%create DH table
%     a    d    alpha
dh=[  700  312  90  -180  180;...
     1100    0   0  -180  180;...
      230    0  90  -180  180;...
        0 1250 -90  -180  180;...
        0    0  90  -180  180;...
        0  229   0  -360  360;];

  perr=0;
  aerr=0;
  
  
  options=opt_parser(varargin);
  if options.isKey('perr')
      perr=options('perr');
  end
  
  if options.isKey('aerr')
      aerr=options('aerr');
  end
  %apply error  
  for i=1:size(dh,1)
      for j=1:2
          dh(i,j) = dh(i,j) + (rand)*perr*2;
      end
      for j=3:3
          dh(i,j) = dh(i,j) + (rand)*aerr*2;
      end
  end
end