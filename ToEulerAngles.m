function [sol1,sol2]=ToEulerAngle(M)
%ToEulerAngle Convert rotation matrix to Euleur angle
%   [sol1,sol2]=ToEulerAngle(M)
%   M: rotation matrix or pose matrix
%   sol1,sol2 :two solutions in degree
    if M(3,1)==-1       
       phi=0;
       theta=pi/2;
       psi=theta+atan2(M(1,2),M(1,3));
       psi1=psi;
       phi1=phi;
       theta1=theta;
    elseif M(3,1)==1
       phi=0;
       theta=-pi/2;
       psi=atan2(-M(1,2),-M(1,3))-theta;
       phi1=phi;
       theta1=theta;
       psi1=psi;
    else
        theta=-asin(M(3,1));
        theta1=pi-theta;
        psi=atan2(M(3,2),M(3,3));
        psi1=atan2(-M(3,2),-M(3,3));
        phi=atan2(M(2,1),M(1,1));
        phi1=atan2(-M(2,1),-M(1,1));
    end
    rad2deg=180/pi;
    sol1=[psi,theta,phi]*rad2deg;
    sol2=[psi1,theta1,phi1]*rad2deg;
end
