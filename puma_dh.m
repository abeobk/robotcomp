function dh=puma_dh(varargin)
% create PUMA560 DH table (angles are in degree)
% Usage: dh=puma_dh(options)
%    'perr' - position error magnitude (mm)  (i.e. 0.5mm)
%    'aerr' - angular error offset (degree)  (i.e. 0.2 degree)

%create DH table
dh=[  0    0    90  -160  160;...
    432    0     0   -45  225;...
     20  150   -90  -225   45;...
      0  432    90  -110  170;...
      0    0   -90  -100  100;...
      0    0     0  -266  266];
  
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
  for i=1:6
      for j=1:2
          dh(i,j) = dh(i,j) + (rand)*perr*2;
      end
      for j=3:3
          dh(i,j) = dh(i,j) + (rand)*aerr*2;
      end
  end
end