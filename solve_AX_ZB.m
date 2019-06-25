function [X, Z] =solve_AX_ZB(As,Bs)
% Function solve_AX_XB
%    Solve AX=ZB equation for X
% Usage: X=solve_AX_ZB(As,Bs)
% Input:
%   As : list of 4x4 matrices A, ie. As(:,:,1) = A1
%   Bs : list of 4x4 matrices B, ie. Bs(:,:,1) = B1
% Return:
%   [X, Z]  : 4x4 solution matrices

A_=[];
b_=[];
I3=eye(3);
Z3x9 = zeros(3,9);
Z9x3 = zeros(9,3);

for i=1:length(As)
   RA=t2r(As(:,:,i));
   tA=As(1:3,4,i);
   RB=t2r(Bs(:,:,i));
   tB=Bs(1:3,4,i);
   
   A_ =[A_; [kromul(RA,I3)  kromul(-I3,RB') Z9x3 Z9x3;...
        Z3x9 kromul(I3,tB') -RA I3]];
   b_ = [b_ ; [zeros(9,1); tA]];
end

AT=A_';
ATA=AT*A_;
ATb=AT*b_;
x=inv(ATA)*ATb;

RX=reshape(x(1:9),[3 3])';
tX=x(19:21);
RZ=reshape(x(10:18),[3 3])';
tZ=x(22:24);

X=eye(4);
X(1:3,1:3)=RX;
X(1:3,4)=tX;

Z=eye(4);
Z(1:3,1:3)=RZ;
Z(1:3,4)=tZ;
% 
% for i=1:length(As)
%    AX=As(:,:,i)*X
%    ZB=Z*Bs(:,:,i)
% end

end