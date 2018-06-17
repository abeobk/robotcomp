function p = tr2pose(T)
% Convert from transformation homography to pose
% Usage p = tr2pose(T)
%   T  : 4x4 input transformation homography
% Return:
%   p  : equivalent pose (X Y Z rx ry rz)
  r = tr2rpy(T,'deg');
  t = T(1:3,4)';
  p=[t r];
end