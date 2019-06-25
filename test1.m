a=[ 1 2  3];
th=pi/5;

Rz=rotz(th);
a=a/norm(a);
d=norm(a(2:3))
Rx=rotx(atan2(a(2)/d,a(3)/d));
Ry=roty(atan2(-a(1),d));
R=inv(Rx)*inv(Ry)*Rz*Ry*Rx

st=sin(th);
ct=cos(th);
K=skew(a);
R1=eye(3)+st*K+(1-ct)*K*K