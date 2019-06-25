function S = skew(v)
%Function: skew
%   convert a 3x1 vector to skew symetric matrix
%Usage: S=skew(v)
%Input:
%   v: input vector (3x1)
%Return:
%   S: skew matrix of v
S=[0 -v(3) v(2);...
    v(3) 0 -v(1);...
    -v(2) v(1) 0];
end