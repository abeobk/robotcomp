%Clear all
clear all;
close all;


model_angular_err = 1;
model_position_err= 5;


%create theoretical model
robot_t = create_robot_model(puma_dh(),...
    'deg',true)

%create actual model
robot_a = create_robot_model(...
     puma_dh('perr',model_position_err,...
    'aerr',model_angular_err),...
    'deg',true)


%Data ranges
range=[400  600;... %x range
       -100  100;... %y range
       100   300];   %z range
   
%Data step
step=[50 50 50];    %x,y,z resolution


%generate desired pose data
Pd = gen_pose(range,step,...
             3,...            % generate 3 poses for each pos
            'ascl',1);        % random angle factor = 0.5

% Pd=gen_rand_pose(range,300);

%calculate actual pose
[Pt, Pa]=calc_actual_pose(robot_t,... %theoretical model
    robot_a,... %actual model
    Pd,... %desired pose
    'show_model',false); %show model

%calc error
Perr= Pt-Pa;
mean_err = mean(Perr)
std_err = std(Perr)


%visualize
figure;
subplot(1,2,1);
hold on
scatter3(Pt(:,1),Pt(:,2),Pt(:,3),'o');
scatter3(Pa(:,1),Pa(:,2),Pa(:,3),'.')
title('Position: Pt vs Pa');

r2d = 180/pi;

subplot(1,2,2);
hold on
scatter3(Pt(:,4)*r2d,Pt(:,5)*r2d,Pt(:,6)*r2d,'o');
scatter3(Pa(:,4)*r2d,Pa(:,5)*r2d,Pa(:,6)*r2d,'.')
title('Angle: Pt vs Pa');

figure;
subplot(1,2,1);
scatter3(Perr(:,1),Perr(:,2),Perr(:,3),'o');
title('Position err (mm)');

subplot(1,2,2);
scatter3(Perr(:,4)*r2d,Perr(:,5)*r2d,Perr(:,6)*r2d,'o');
title('Angle error (deg)');



%Create neural network
net=feedforwardnet([50]);


%normalize data
pf = 1/1000;
af = 1/pi;
Pt_n = Pt;
Pt_n(:,1:3) = Pt_n(:,1:3)*pf;
Pt_n(:,4:6) = Pt_n(:,4:6)*af;

Pa_n = Pa;
Pa_n(:,1:3) = Pa_n(:,1:3)*pf;
Pa_n(:,4:6) = Pa_n(:,4:6)*af;

net.trainFcn='trainlm';
net.trainParam.epochs = 10000;
net.trainParam.lr=0.01;
net.trainParam.min_grad=1e-12;
net.trainParam.max_fail=10;
%configure input output
net=configure(net,Pa_n',Pt_n')
view(net);

%train the network to estimate from actual pose to theoretical pose
[net,tr]=train(net,Pa_n',Pt_n');

%Validation

Pd_v = gen_rand_pose(range,500,'asl',1);
figure;
scatter3(Pd_v(:,1),Pd_v(:,2),Pd_v(:,3),'.');
title('Test position');

validate_ann_compensator(robot_t,robot_a,net,Pd_v,pf,af);

Pd_v1 = gen_circle_path(range,'asl',0.5);
figure;
scatter3(Pd_v1(:,1),Pd_v1(:,2),Pd_v1(:,3),'.');
title('Test circle');

validate_ann_compensator(robot_t,robot_a,net,Pd_v1,pf,af);


