function M=RotY3(angle)
%RotY3  Create rotation matrix about Y axis by a given angle
%   M=RotY3(angle)
%   angle is in radian
    ct=cos(angle);
    st=sin(angle);
    M=[ct 0 st;
        0 1 0;
        -st 0 ct];
end