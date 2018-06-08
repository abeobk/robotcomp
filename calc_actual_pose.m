function [Pt,Pa] = calc_actual_pose(robot_t, robot_a, Pd,varargin)
% Calculate actual poses Pa given desired poses Pd
% Usage: [Pt,Pa] = calc_actual_pose(robot_t,robot_a,Pd)
%    robot_t : Theoretical robot model
%    robot_a : Actual robot model
%    Pd      : Desired pose [x y z rx ry rz]
%              positions are in mm, angles are in radian
%    options: 'show_model' : true to show
% Return:
%    [Pt, Pa]: Pt - theoretical pose, Pa - actual pose

    options = opt_parser(varargin);
    
    show_model=false;
    if options.isKey('show_model')
        show_model=options('show_model');
    end
    
    npose=length(Pd);
    Pa = [];
    Pt=[];
    for i=1: npose
        pd=Pd(i,:);
        td=pd(1:3);
        rd=pd(4:6);
        trd=rpy2tr(rd);
        trd(1:3,4)=td';        
        qd=robot_t.ikine6s(trd,'l','u','n');        
        if show_model
            robot_t.plot(qd,'tilesize',200);
        end        
        if ~isempty(qd)
            tra=robot_a.fkine(qd).T;
            ra=fix_angle(tr2rpy(tra),rd);
            ta=tra(1:3,4)';    
            pa=[ta ra];
            Pa=[Pa;pa];
            Pt=[Pt;pd];
        end        
    end
end