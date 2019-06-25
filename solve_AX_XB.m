function X=solve_AX_XB(As,Bs)
% Function solve_AX_XB
%    Solve AX=XB equation for X
% Usage: X=solve_AX_XB(As,Bs)
% Input:
%   As : list of 4x4 matrices A, ie. As(:,:,1) = A1
%   Bs : list of 4x4 matrices B, ie. Bs(:,:,1) = B1
% Return:
%   X  : 4x4 solution matrix

    %Compute M = sum(log(r_Bi)*log(r_Ai)') for all i
    M = zeros(3,3);
    for i=1:length(As)
        r_A = As(1:3,1:3,i);
        r_B = Bs(1:3,1:3,i);
        logA = logR_SO3(r_A);
        logB = logR_SO3(r_B);
        M = M+logB*logA';
    end
    %compute MtM = M'*M
    MtM = M'*M;

    %SVD  MtM = U*S*V'
    [U,S,V]=svd(MtM);

    %S1 = 1/sqrt(S)
    S1 = S;
    S1(1,1) = 1/sqrt(S(1,1));
    S1(2,2) = 1/sqrt(S(2,2));
    S1(3,3) = 1/sqrt(S(3,3));

    %M1=U*S1*V'
    M1 = U*S1*V';

    %Compute r_X
    r_X = M1*M';

    
    %Compute t_X
    C=[];
    d=[];
    
    for i=1:length(As)
        r_A = As(1:3,1:3,i);
        t_A = As(1:3,4,i);
        t_B = Bs(1:3,4,i);
        C=[C;eye(3,3)-r_A];
        d=[d;t_A-r_X*t_B];        
    end
    
    Ct = C';
    CtC = Ct*C;
    Ctd = Ct*d;
    t_X=inv(CtC)*Ctd;
    X = eye(4,4);
    
    X(1:3,1:3)=r_X;
    X(1:3,4)=t_X;    
end