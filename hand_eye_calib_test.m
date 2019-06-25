%Clear all
clear all;
close all;



model_angular_err = 0.5; %0.5 degree error
model_position_err= 1;   %1mm link error

robot_t_dh = puma_dh()
robot_a_dh = puma_dh('perr',model_position_err, 'aerr', model_angular_err)


%create theoretical model
robot_t = create_robot_model(robot_t_dh,'deg',true)

%create actual model
robot_a = create_robot_model(robot_a_dh,'deg',true)


%Data ranges
range=[ 300  600;... %x range
       -100  100;... %y range
       500   600];   %z range
    
%Data step
step=[100 100 100];    %x,y,z resolution

%generate desired pose data
Pd = gen_pose(range,step,...
              3,...             % generate 3 poses for each pos
              'ascl',1);        % random angle factor = 0.5
        
%calculate actual pose
[Pt, Pa]=calc_actual_pose(robot_t,... %theoretical model
    robot_a,... %actual model
    Pd,... %desired pose
    'show_model',false); %show model

%note that Pt = Pd

% Generate X
Px=[100 200 -100 0.5 -0.3 1];
X=pose2tr(Px);

%Generate board coordinate
Pb=[1000 0 -100 1 -0.5 0.7]
tr_rb=pose2tr(Pb);


T_b = [];
T_r = [];

for i =1:length(Pa)
  tr_r = pose2tr(Pa(i,:));
  T_r(:,:,i)= pose2tr(Pt(i,:));
  T_b(:,:,i)= inv(X)*inv(tr_r)*tr_rb;
end


%Solve AX=XB, aka. hand-eye calibration
for i=1:length(T_b)-1
    As(:,:,i) = inv(T_r(:,:,i+1))*T_r(:,:,i);
    Bs(:,:,i) = T_b(:,:,i+1)*inv(T_b(:,:,i));
end

X_calib= solve_AX_XB(As,Bs);

%Show that X ~ X_calib
abs(X-X_calib)

%Calculate mean board pose
P_b_mean =zeros(1,6);

P_b=[];
for i=1:length(Pa)
   tr_Bi = T_r(:,:,i)*X_calib*T_b(:,:,i);
   r_Bi = tr2rpy(tr_Bi);
   t_Bi = tr_Bi(1:3,4)'; 
   p_Bi = [t_Bi r_Bi]; 
   P_b  =  [P_b;p_Bi];
   P_b_mean=P_b_mean+p_Bi;  
end

P_b_mean = mean(P_b);
std(P_b)
tr_rb_mean=pose2tr(P_b_mean);

figure;
subplot(1,2,1);
hold on
scatter3(P_b(:,1),P_b(:,2),P_b(:,3),'.')
scatter3(P_b_mean(:,1),P_b_mean(:,2),P_b_mean(:,3),'o')
title('Board location');

r2d = 180/pi;
subplot(1,2,2);
hold on;
scatter3(P_b(:,4)*r2d,P_b(:,5)*r2d,P_b(:,6)*r2d,'.');
scatter3(P_b_mean(:,4)*r2d,P_b_mean(:,5)*r2d,P_b_mean(:,6)*r2d,'o');
title('Board orientation');

pause

%Prepare training data
%normalize data
pf = 1/1000;
af = 1/pi;
Pt_n = Pt;
Pt_n(:,1:3) = Pt_n(:,1:3)*pf;
Pt_n(:,4:6) = Pt_n(:,4:6)*af;

Pt1_n = Pt;
%For each theoretical pose, compute actual pose
for i =1:length(Pt_n)
   Tt1 = tr_rb_mean*inv(T_b(:,:,i))*inv(X_calib);
   Pt1_n(i,1:3)=Tt1(1:3,4)';
   Pt1_n(i,4:6)=fix_angle(tr2rpy(Tt1),Pt(i,4:6));      
end

%normalize
Pt1_n(:,1:3) = Pt1_n(:,1:3)*pf;
Pt1_n(:,4:6) = Pt1_n(:,4:6)*af;

%Create neural network
net=feedforwardnet([50]);

net.trainFcn='trainlm';
net.trainParam.epochs = 10000;
net.trainParam.lr=0.01;
net.trainParam.min_grad=1e-9;
net.trainParam.max_fail=10;
%configure input output
net=configure(net,Pt1_n',Pt_n')
view(net);

%train the network to estimate from actual pose to theoretical pose
[net,tr]=train(net,Pt1_n',Pt_n');



%Validation

Pd_v = gen_rand_pose([200 700; -200 200;100 500],500,'asl',1);
%Pd_v = gen_circle_path(range,'asl',0.5);
figure;
scatter3(Pd_v(:,1),Pd_v(:,2),Pd_v(:,3),'.');
title('Test position');


Pb_v=[];
Pb_v1=[];

for i=1:length(Pd_v)
    %desired pose
    pd = Pd_v(i,:);
    td=pd(1:3);
    rd=pd(4:6);
    
    %convert to norm pose
    pd_n=[td*pf rd*af];
    
    %predict with ann
    pp_ann=net(pd_n')';
    tp=pp_ann(1:3)/pf;
    rp=pp_ann(4:6)/af;
    
    %predicted pose
    pp=[tp rp];
    
    %calculate joint angles
    %Predicted transform
    Tp=rpy2tr(rp);    
    Tp(1:3,4)=tp';

    
    %Desirired transform
    Td=rpy2tr(rd);
    Td(1:3,4)=td';
    
    
    % WE input the predicted  value to console
    % Ta should then be calculated from Tp
    qt=robot_t.ikine6s(Tp,'l','u','n');
    Ta=robot_a.fkine(qt).T;
       
    %Compute real board to camera transformation
    T2 = inv(X)*inv(Ta)*tr_rb;
    
    
    Tb = Td*X_calib*T2;
    r_Tb = tr2rpy(Tb);
    t_Tb = Tb(1:3,4)'; 
   
    %This should be more accurate
    Pb_v1=[Pb_v1; [t_Tb r_Tb]-P_b_mean];
    
    
    Tb = Tp*X_calib*T2;
    r_Tb = tr2rpy(Tb);
    t_Tb = Tb(1:3,4)'; 
    Pb_v=[Pb_v; [t_Tb r_Tb]-P_b_mean];
    
end

Pb_v_mean=mean(Pb_v)
Pb_v_std = std(Pb_v)
Pb_v_mean1=mean(Pb_v1)
Pb_v_std1 = std(Pb_v1)

figure;
subplot(1,2,1);
hold on
scatter3(Pb_v(:,1),Pb_v(:,2),Pb_v(:,3),'+')
scatter3(Pb_v1(:,1),Pb_v1(:,2),Pb_v1(:,3),'.')
title('Board location');

r2d = 180/pi;
subplot(1,2,2);
hold on;
scatter3(Pb_v(:,4)*r2d,Pb_v(:,5)*r2d,Pb_v(:,6)*r2d,'+');
scatter3(Pb_v1(:,4)*r2d,Pb_v1(:,5)*r2d,Pb_v1(:,6)*r2d,'.');
title('Board orientation');

Pb_v_diff = abs(P_b_mean-Pb_v_mean)
Pb_v_diff1 = abs(P_b_mean-Pb_v_mean1)
% 
% validate_ann_compensator(robot_t,robot_a,net,Pd_v,pf,af);
% 
% Pd_v1 = gen_circle_path(range,'asl',0.5);
% figure;
% scatter3(Pd_v1(:,1),Pd_v1(:,2),Pd_v1(:,3),'.');
% title('Test circle');
% 
% validate_ann_compensator(robot_t,robot_a,net,Pd_v1,pf,af);
% 
% 
