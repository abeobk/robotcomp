function T = pose2tr(p,varargin)
% Convert from pose to transform matrix
% Usage T = pose2tr(p)
%   p  : input pose (X Y Z rx ry rz)
% Return:
%   T  : equivalent transformation matrix
  T = rpy2tr(p(4:6),varargin);
  T(1:3,4)=p(1:3)';
end