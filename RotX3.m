function M=RotX3(angle)
%RotX3  Create rotation matrix about X axis by a given angle
%   M=RotX3(angle)
%   angle is in radian
    ct=cos(angle);
    st=sin(angle);
    M=[1 0 0;
       0 ct -st;
       0 st ct];
end