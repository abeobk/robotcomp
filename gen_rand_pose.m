function P = gen_rand_pose(range,N,varargin)
% Generate random poses
% Usage: P = gen_rand_pose(range, N)
%    range = [xmin xmax; ymin ymax; zmin zmax]
%    N     : number of poses
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
    for i=1:N
        t=[rand*(xmax-xmin)+xmin,...
            rand*(ymax-ymin)+ymin,...
            rand*(zmax-zmin)+zmin];
        
        r=[(rand-0.5)*ascl+pi, ...
            (rand-0.5)*ascl,...
            (rand-0.5)*ascl];
        P=[P;[t r]];
    end
end