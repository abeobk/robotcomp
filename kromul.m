function K = kromul(A,B)
%perform Kronecker multiplication
 K=[];
 [h w]=size(A);
 for r=1:h
     Kr=[];
     for c=1:w
         Kr=[Kr A(r,c)*B];
     end
     K=[K;Kr];
 end
end