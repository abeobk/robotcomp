function robot=create_robot_model(DH,varargin)
%Function: create_puma_model 
%    Create a 6DOF, spherical wrist puma-liked manipulator model with DH table
%
%Syntax:  
%    robot = function_name(DH)
%
%Inputs:
%    DH = [a d alpha qmin qmax]
%         a     - link length
%         d     - link offset
%         alpha - common nomal angle
%         qmin  - lower limit of joint angle
%         qmax  - upper limit of joint angle
%         Each row is a joint, angles are in radian
%    Options:
%        'deg': true - if angle is in degree, default is radian
%        'mdl': model name
%Outputs:
%    robot - output robot model
%
%Author: 
%    Do Van Phu
%    Abeosystem Co.,LTD. Korea.
%    email address: abeobk@gmail.com
    
    %parse options
    options=opt_parser(varargin);

    af=1;
    if options.isKey('deg')
        if options('deg')
            af=pi/180;
        end
    end
    
    model_name='PUMA560';
    if options.isKey('mdl')
        model_name=options('mdl');
    end
    
    a=DH(:,1);
    d=DH(:,2);
    alpha=DH(:,3);
    qmin=DH(:,4);
    qmax=DH(:,5);
        
    for i=1:size(DH,1)
        L(i)=Revolute('d', d(i),...
            'a', a(i), ...
            'alpha',alpha(i)*af,...
            'qlim', [qmin(i) qmax(i)]*af);
    end
    robot = SerialLink(L,'name',model_name);
end
