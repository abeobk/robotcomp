function M=RotZ3(angle)
%RotZ3  Create rotation matrix about Z axis by a given angle
%   M=RotZ3(angle)
%   angle is in radian
    ct=cos(angle);
    st=sin(angle);
    M=[ct -st 0;
        st ct 0;
        0 0 1];
end