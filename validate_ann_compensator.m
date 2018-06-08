function validate_ann_compensator(robot_t, robot_a, ann, Pd, pf, af)

npose = length(Pd);

Perr=[];
Pcerr=[];

for i=1:npose
    % desired pose
    pd = Pd(i,:);
    td=pd(1:3);
    rd=pd(4:6);
    
    %convert to norm pose
    pd_n=[td*pf rd*af];
    
    %predict with ann
    pp_ann=ann(pd_n')';
    tp=pp_ann(1:3)/pf;
    rp=pp_ann(4:6)/af;
    
    %predicted pose
    pp=[tp rp];
    
    %calculate joint angles
    Tp=rpy2tr(rp);
    Tp(1:3,4)=tp';
    qt=robot_t.ikine6s(Tp,'l','u','n');
    
    
    %apply to actual model
    Ta=robot_a.fkine(qt).T;
    ra=fix_angle(tr2rpy(Ta),rd);
    ta=Ta(1:3,4)';
        
    
    
    perr=pp-pd;    
    perr(4:6)=perr(4:6)*180/pi;
    Perr=[Perr; perr];
    
    %real pose to input to the robot_t to produce desired pose
    pa=[ta ra];
    pcerr=pa-pd;
    pcerr(4:6)=pcerr(4:6)*180/pi;     
    Pcerr=[Pcerr; pcerr];
end


Perr_mean=mean(Perr)
Perr_std =std(Perr)
Pcerr_mean=mean(Pcerr)
Pcerr_std =std(Pcerr)
angular_improve = [100 100 100]- 100*abs(Pcerr_mean(1:3))./abs(Perr_mean(1:3))
position_improve = [100 100 100]- 100*abs(Pcerr_mean(4:6))./abs(Perr_mean(4:6))

figure;
subplot(2,2,1);
scatter3(Perr(:,1),Perr(:,2),Perr(:,3),'.');
title({'Angular error (deg)',...
    sprintf('mean=[%f %f %f]',Perr_mean(1:3)),...
    sprintf('std=[%f %f %f]',Perr_std(1:3))},'FontSize',12);
xlabel('RX');ylabel('RY');zlabel('RZ');

subplot(2,2,2);
scatter3(Pcerr(:,1),Pcerr(:,2),Pcerr(:,3),'.');
title({'Compensated angular error (deg)',...
    sprintf('mean=[%f %f %f]',Pcerr_mean(1:3)),...
    sprintf('std=[%f %f %f]',Pcerr_std(1:3))},'FontSize',12);
xlabel('RX');ylabel('RY');zlabel('RZ');

subplot(2,2,3);
scatter3(Perr(:,4),Perr(:,5),Perr(:,6),'.');
title({'Position error (mm)',...
    sprintf('mean=[%f %f %f]',Perr_mean(4:6)),...
    sprintf('std=[%f %f %f]',Perr_std(4:6))},'FontSize',12);
xlabel('X');ylabel('Y');zlabel('Z');

subplot(2,2,4);
scatter3(Pcerr(:,4),Pcerr(:,5),Pcerr(:,6),'.');
title({'Compensated position error (mm)',...
    sprintf('mean=[%f %f %f]',Pcerr_mean(4:6)),...
    sprintf('std=[%f %f %f]',Pcerr_std(4:6))},'FontSize',12);
xlabel('X');ylabel('Y');zlabel('Z');

figure;
subplot(1,2,1);
hold on
scatter3(Perr(:,1),Perr(:,2),Perr(:,3),'o');
scatter3(Pcerr(:,1),Pcerr(:,2),Pcerr(:,3),'.');
title('Angular errors (deg)');
xlabel('RX');ylabel('RY');zlabel('RZ');


subplot(1,2,2);
hold on
scatter3(Perr(:,4),Perr(:,5),Perr(:,6),'o');
scatter3(Pcerr(:,4),Pcerr(:,5),Pcerr(:,6),'.');
title('Position errors (mm)');
xlabel('X');ylabel('Y');zlabel('Z');
end