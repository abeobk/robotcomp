c=[(range(1,1)+range(1,2))/2 (range(2,1)+range(2,2))/2 (range(3,1)+range(3,2))/2]
traj=[];

RT1=[];

for theta_deg=0:360
    theta=theta_deg*pi/180;
    x=c(1)+100*cos(theta);
    y=c(2)+100*sin(theta);
    z=sin(theta*5)*100+c(3);
    
    rx=pi+sin(theta*3)*0.3;
    ry=sin(theta*5+3)*0.1;
    rz=cos(theta*7-5)*0.1;
    
    RT1=[RT1; [rx ry rz x y z]];
    
    traj=[traj;[x  y  z]];
end
scatter3(traj(:,1), traj(:,2), traj(:,3),'.');
validate_ann_compensator(puma,puma1,net,RT1,rotation_factor,position_factor)
