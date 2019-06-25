%Clear all
clc
clear all;
close all;



model_angular_err = 0.2; %0.5 degree error
model_position_err= 2;   %1mm link error

robot_t_dh = puma_dh()
robot_a_dh = puma_dh('perr',model_position_err, 'aerr', model_angular_err)

% robot_a_dh = [... % puma_dh('perr',model_position_err, 'aerr', model_angular_err)
%     1.2346    1.0576   90.0488 -160.0000  160.0000;...
%   432.5320    1.7289    0.0507  -45.0000  225.0000;...
%    21.8745  151.7438  -89.9561 -225.0000   45.0000;...
%     0.0939  433.8152   90.1715 -110.0000  170.0000;...
%     1.1206    0.7953  -89.9042 -100.0000  100.0000;...
%     1.2220    1.3281    0.0791 -266.0000  266.0000];


%create theoretical model
robot_t = create_robot_model(robot_t_dh,'deg',true)

%create actual model
robot_a = create_robot_model(robot_a_dh,'deg',true)


%Data ranges
range=[ 200  600;... %x range
        -200  200;... %y range
        400   600];   %z range
    
%Data step
step=[200 200 200];    %x,y,z resolution

%generate desired pose data
Pd = gen_pose(range,step,...
              3,...             % generate 3 poses for each pos
              'ascl',2);        % random angle factor = 0.5
        
%calculate actual pose
[Pt, Pa]=calc_actual_pose(robot_t,... %theoretical model
    robot_a,... %actual model
    Pd,... %desired pose
    'show_model',false); %show model

%note that Pt = Pd

%Generate X
Px=[120 100 -150 0.5 -0.3 1];
X=pose2tr(Px)

%Generate board coordinate
Pb=[300 450 0 1 -0.5 0.7]
tr_rb=pose2tr(Pb);

% board pose: obtained from real model
T_b = [];
% robot poseh: obtained from nominal model
T_r = [];

for i =1:length(Pa)
  % Nominal pose
  T_r(:,:,i)= pose2tr(Pt(i,:));
  % Actual pose tr_r
  tr_r = pose2tr(Pa(i,:));
  % Boarod pose
  T_b(:,:,i)= inv(X)*inv(tr_r)*tr_rb;
end


%Solve AX=XB, aka. hand-eye calibration
for i=1:length(T_b)-1
    As(:,:,i) = inv(T_r(:,:,i+1))*T_r(:,:,i);
    Bs(:,:,i) = T_b(:,:,i+1)*inv(T_b(:,:,i));
end

X_calib= solve_AX_XB(As,Bs)

%Show that X ~ X_calib
delta_X = abs(X-X_calib)

%Calculate mean board pose
P_b_mean =zeros(1,6);

P_b=[];
for i=1:length(Pa)
   tr_Bi = T_r(:,:,i)*X_calib*T_b(:,:,i);
   r_Bi = tr2rpy(tr_Bi);
   %r_Bi = fix_angle(r_Bi,Pb(4:6),'deg',true);
   t_Bi = tr_Bi(1:3,4)'; 
   p_Bi = [t_Bi r_Bi]; 
   P_b  =  [P_b;p_Bi];
   P_b_mean=P_b_mean+p_Bi;  
end

P_b_mean = mean(P_b)
std_P_b = std(P_b)
tr_rb_mean=pose2tr(P_b_mean)

% figure;
% subplot(1,2,1);
% hold on
% scatter3(P_b(:,1),P_b(:,2),P_b(:,3),'.')
% scatter3(P_b_mean(:,1),P_b_mean(:,2),P_b_mean(:,3),'o')
% title('Board location');
% 
% r2d = 180/pi;
% subplot(1,2,2);
% hold on;
% scatter3(P_b(:,4)*r2d,P_b(:,5)*r2d,P_b(:,6)*r2d,'.');
% scatter3(P_b_mean(:,4)*r2d,P_b_mean(:,5)*r2d,P_b_mean(:,6)*r2d,'o');
% title('Board orientation');


%searching for best result model
min_std_P_b = std_P_b;
min_robot_a_dh=robot_t_dh;
p_coeff = 5/10;
a_coeff=10/1;
crr_perr = norm(std_P_b(1:3))*p_coeff
crr_aerr = norm(std_P_b(4:6))*a_coeff
iter =0;
hold on
std_P_bs=[]
iters=[]





while(true)
   %starting with current best solution
   robot_a1_dh = min_robot_a_dh;
   
   for i=1:size(robot_a1_dh,1)
       for j=1:2
         robot_a1_dh(i,j) = robot_a1_dh(i,j) +  (0.5-rand)*crr_perr;
       end
       for j=3:3
         robot_a1_dh(i,j) = robot_a1_dh(i,j) +  (0.5-rand)*crr_aerr;
       end
   end

       

   %min_robot_a_dh
   %robot_a1_dh
   
   %create actual model based on new randomized DH table
   robot_a1 = create_robot_model(robot_a1_dh,'deg',true);
   
   %calculate actual pose
   [Pt, Pa1]=calc_actual_pose(robot_t,... %theoretical model
       robot_a1,... %actual model
       Pd,... %desired pose
       'show_model',false); %show model

   % board pose: obtained from real model
   T_b = [];
   % robot poseh: obtained from nominal model
   T_r = [];
   
   for i =1:length(Pa)
       % Nominal pose
       T_r(:,:,i)= pose2tr(Pa1(i,:));
       % Actual pose tr_r
       tr_r = pose2tr(Pa(i,:));
       % Board pose
       T_b(:,:,i)= inv(X)*inv(tr_r)*tr_rb;
   end
   
   
   %Solve AX=XB, aka. hand-eye calibration
   for i=1:length(T_b)-1
       As(:,:,i) = inv(T_r(:,:,i+1))*T_r(:,:,i);
       Bs(:,:,i) = T_b(:,:,i+1)*inv(T_b(:,:,i));
   end
   
   X_calib= solve_AX_XB(As,Bs);
   
   %Show that X ~ X_calib
   delta_X = abs(X-X_calib);
   
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
   std_P_b = std(P_b);
   
   %update if found new best solution
   if(norm(std_P_b(1:3))<norm(min_std_P_b(1:3))) 
      min_robot_a_dh = robot_a1_dh;
      crr_perr = norm(std_P_b(1:3))*p_coeff
      crr_aerr = norm(std_P_b(4:6))*a_coeff
      min_std_P_b = std_P_b      
      dh_diff=abs(robot_a1_dh-robot_a_dh)
      if(crr_perr<1e-4 && crr_aerr<1e-4)
          break;
      end
      iter
      %pause      
   end
   %tr_rb_mean=pose2tr(P_b_mean)    
   iter =iter +1;
   std_P_bs = [std_P_bs; std_P_b];
   iters=[iters; iter];
   plot(iters,std_P_bs(:,1),'r-');
   plot(iters,std_P_bs(:,2),'g-');
   plot(iters,std_P_bs(:,3),'b-');
   drawnow

end

robot_a_dh
robot_a1_dh
delta_X
Pb
P_b_mean
std_P_b