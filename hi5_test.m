clear all;
%close all;

format short g

%create theoretical model
robot_t = create_robot_model(hi5_dh(),...
    'mdl','Hi5',...
    'deg',true)

deg2rad=pi/180;

%q: 0 21.75 119.56 -20 50.57 55.81 54.27
%p: 544.01  148.25  1139.4   44.647   -29.538  83.8

q=[0 90 0 0 0 0]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)
% 

% pause
% q=[90 90 0 90 0 0]*deg2rad;
% robot_t.plot(q)
% 
% T = robot_t.fkine(q).T
% p = tr2pose(T)
% 
% pause
% 
% q=[0 90 90 90 0 0]*deg2rad;
% robot_t.plot(q)
% 
% T = robot_t.fkine(q).T
% p = tr2pose(T)
% 
% pause
% 
% q=[90 90 90 90 0 0]*deg2rad;
% robot_t.plot(q)
% 
% T = robot_t.fkine(q).T
% p = tr2pose(T)
% 
% pause
% 
% q=[0 0 90 90 0 0]*deg2rad;
% robot_t.plot(q)
% 
% T = robot_t.fkine(q).T
% p = tr2pose(T)
% 
% pause
% 
% q=[90 0 90 90 0 180]*deg2rad;
% robot_t.plot(q)
% 
% T = robot_t.fkine(q).T
% p = tr2pose(T)
% 
