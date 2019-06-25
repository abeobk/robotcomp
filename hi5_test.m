clear all;
%close all;

format short g

%create theoretical model
robot_t = create_robot_model(ha006_dh(),...
    'mdl','Hi5',...
    'deg',true)

deg2rad=pi/180;

q=[0 90 0 0 -90 0 180]*deg2rad;
robot_t.plot(q)

pause
q=[90 90 0 90 0 0 180]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)

pause

q=[0 90 90 90 0 0 180]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)

pause

q=[90 90 90 90 0 0 180]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)

pause

q=[0 0 90 90 0 0 180]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)

pause

q=[90 0 90 90 0 180 180]*deg2rad;
robot_t.plot(q)

T = robot_t.fkine(q).T
p = tr2pose(T)

