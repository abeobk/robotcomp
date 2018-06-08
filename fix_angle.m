function aout = fix_angle(ain,aref)
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
end