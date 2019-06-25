function P = gen_pose(range,step,rot_cnt, varargin)
% Generate poses
% Usage: P = gen_pose(range, step, rot_cnt)
%    range = [xmin xmax; ymin ymax; zmin zmax]
%    step  = [xstep ystep zstep]
%    rot_cnt = number of random pose at each sample positin
% Options:
%    'ascl' - angular scale factor, default=0.5
% Return: pose array
    xmin=range(1,1);
    xmax=range(1,2);
    xstep=step(1);
    
    ymin=range(2,1);
    ymax=range(2,2);
    ystep=step(2);
    
    zmin=range(3,1);
    zmax=range(3,2);
    zstep=step(3);
    
    ascl=0.5;
    options=opt_parser(varargin);
    
    if options.isKey('ascl')
        ascl=options('ascl');
    end

    
    P=[];
    for z=zmin:zstep:zmax
        for y=ymin:ystep:ymax
            for x=xmin:xstep:xmax                
                t=[x y z];
                for i=1:rot_cnt
                    r=[(rand-0.5)*ascl+pi, ...
                        (rand-0.5)*ascl,...
                        (rand-0.5)*ascl];
                    P=[P;[t r]];
                end
            end
        end
    end    
end