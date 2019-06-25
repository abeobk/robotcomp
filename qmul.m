function q = qmul(q1,q2)
%quaternion multiplication
    a0=q1(1);
    a =q1(2:4);
    b0=q2(1);
    b =q2(2:4);
    q(1)=a0*b0 - dot(a,b);
    q(2:4) = a0*b+b0*a+cross(a,b);
end