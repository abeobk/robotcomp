function P = gen_circle_path(range,varargin)
% Generate circle path
% Usage: P = gen_circle_path(range, N)
%    range = [xmin xmax; ymin ymax; zmin zmax]
% Options:
%    'ascl' - angular scale factor, default=0.5
% Return: pose array
    xmin=range(1,1);
    xmax=range(1,2);

    ymin=range(2,1);
    ymax=range(2,2);

    zmin=range(3,1);
    zmax=range(3,2);

    ascl=0.5;
    options=opt_parser(varargin);

    if options.isKey('ascl')
        ascl=options('ascl')
    end

    P=[];
    for theta_deg=0:360
        theta=theta_deg*pi/180;
        t=[(xmin+xmax)/2+(xmax-xmin)/3*cos(theta),...
            (ymin+ymax)/2+(ymax-ymin)/3*sin(theta),...
            sin(theta*5)*(zmax-zmin)/3+(zmin+zmax)/2];
       
        r=[pi+sin(theta*3)*ascl,...
            sin(theta*5+3)*ascl,...
            cos(theta*7-5)*ascl];
        P=[P;[t r]];
    end
end