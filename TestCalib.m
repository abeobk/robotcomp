clc
%clear all;
%close all;

%read json file
data=json_read('D:/TEMP/calib_data_20180820_calibdata.json');

%number of poses
num_poses = length(data.CamData.Poses);

%extract all camera poses and robot poses
for i=1:num_poses
    HC(:,:,i) = cell2mat(reshape(data.CamData.Poses{i},[4 4])');
    HR(:,:,i) = cell2mat(reshape(data.RobotPoses.(strcat('P',int2str(i-1))).data,[4 4])');
    %Robot poses
    A1s(:,:,i)=HR(:,:,i);
    %Camera poses
    B1s(:,:,i)=inv(HC(:,:,i));
    %convert to quaternions
    qAs(:,i)=tr2q(A1s(:,:,i));
    qBs(:,i)=tr2q(B1s(:,:,i));
end

%Generate A and B for AX=XB solution
idx=1;
for i=1:num_poses
    for j=i+1:num_poses    
        As(:,:,idx)=inv(HR(:,:,j))*HR(:,:,i);
        Bs(:,:,idx)=HC(:,:,j)*inv(HC(:,:,i));
        idx=idx+1;
    end
end

%Solve AX=XB R first then t
X=solve_AX_XB(As,Bs)
%Solve AX=ZB
[X1, Z1]=solve_AX_ZB(A1s,B1s)

[pB_mean, pB_stdev] = calc_calib_board_error(HR,HC,X)
[pB_mean1, pB_stdev1] = calc_calib_board_error(HR,HC,X1)


%filter

close all;
figure;
hold on

plot_pos_stat(pB_mean,pB_stdev);
plot_pos_stat(pB_mean1,pB_stdev1);



%% Quaternion solution
% Simultaneous Robot-World and Hand-Eye Calibration
% Fadi Dornaika, Radu Horaud, 2011
% 
A_=[];
b_=[];
I3=eye(3);


for i=1:length(qAs)
   qA=qAs(:,i);
   qB=qBs(:,i);
   a0=qA(1);
   
   if a0==0 
      continue 
   end
   
   a=qA(2:4);
   b0=qB(1);
   b=qB(2:4);
   
   z0=1;

   A_=[A_;...
      a0*I3+a*a'*(1/a0)+skew(a)  (-b0*I3 -a*b'*(1/a0)+skew(b))];
   b_=[b_;...
       z0*(b - (b0/a0)*a)];
end

%Least square solution
AT=A_';
ATA=AT*A_;
ATb=AT*b_;
u=inv(ATA)*ATb;
x=u(1:3);
z=u(4:6);
x0=dot(a/a0,x)+b0/a0-dot(b/a0,z);
x=[x0 x'];
z=[1 z'];
x=x/norm(x)
z=z/norm(z)
Rx=q2tr(x)
Rz=q2tr(z)









