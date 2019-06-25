function aout = fix_angle(ain,aref, varargin)
    options = opt_parser(varargin);
    deg=false;
    if options.isKey('deg')
        deg= options('deg');
        
    end
    if deg 
        ain =ain * pi/180;
        aref=aref* pi/180;
    end
% Fix robot angle
    aout=ain;
    for i=1:3
       ai=ain(i);
       if abs(ai-aref(i))<pi/2
           continue;
       end
       
       ai=ain(i)+2*pi;
       if abs(ai-aref(i))<pi/2
           aout(i)=ai;
           continue;
       end
       
       ai=ain(i)-2*pi;
       if abs(ai-aref(i))<pi/2
           aout(i)=ai;
           continue;
       end
               
       ai=ain(i)+pi;
       if abs(ai-aref(i))<pi/2
           aout(i)=ai;
           continue;
       end
       
       ai=ain(i)-pi;
       if abs(ai-aref(i))<pi/2
           aout(i)=ai;
           continue;
       end
    end
    
    if deg
        %ain =ain * pi/180;
        %aref=aref* pi/180;
        aout = aout*180/pi;
    end
end