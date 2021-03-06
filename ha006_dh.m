function dh=ha006_dh(varargin)
% create PUMA560 DH table (angles are in degree)
% Usage: dh=puma_dh(options)
%    'perr' - position error magnitude (mm)  (i.e. 0.5mm)
%    'aerr' - angular error offset (degree)  (i.e. 0.2 degree)

%create DH table
%     a    d    alpha
dh=[ 200   360     90   -180  180;...
     560     0      0   -180  180;...
     130     0     90   -180  180;...
       0   620    -90   -180  180;...
       0     0     90   -180  180;...
       0   100      0   -360  360;
       0     0      0      0    0];
% dh=[0   360 0    -180 180;
%     200 0     90   -180 180;
%     560 0     0    -180 180;
%     130 620   90   -180 180;%     
%     0   0    -90  -180 180;
%     0   100   0   -360 360]; 
  
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