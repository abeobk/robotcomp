function qi=qinv(q)
%compute invert of a quaternion
    qi=(1/dot(q,q))*qconj(q);
end