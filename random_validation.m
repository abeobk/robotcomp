c=[(range(1,1)+range(1,2))/2 (range(2,1)+range(2,2))/2 (range(3,1)+range(3,2))/2]
traj=[];

RT1=[];

for i=1:1000
    x=c(1)+100*(rand-0.5);
    y=c(2)+100*(rand-0.5);
    z=c(3)+100*(rand-0.5);
    
    rx=pi+(rand-0.5)*0.5;
    ry=(rand-0.5)*0.5;
    rz=(rand-0.5)*0.5;

    
    RT1=[RT1; [rx ry rz x y z]];
    
    traj=[traj;[x  y  z]];
end

figure;
scatter3(traj(:,1), traj(:,2), traj(:,3),'.');
validate_ann_compensator(puma,puma1,net,RT1,rotation_factor,position_factor)
