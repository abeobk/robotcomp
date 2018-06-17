function lr = logR_SO3(R)
% Function: logR_SO3
%   Calculate log(R) in SO3 where R is rotation matrix
% Syntax: lr = logR_SO3(R)
% Inputs: 
%   R : 3x3 rotation matrix 
% Return:
%   lr: log(R) in SO3

    theta=acos((R(1,1)+R(2,2)+R(3,3)-1)/2);    
    lr=[R(3,2)-R(2,3);...
        R(1,3)-R(3,1);...
        R(2,1)-R(1,2)]*(0.5/sin(theta));
end