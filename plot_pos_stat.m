function plot_pos_stat( pos_mean,pos_stdev )
    [xb,yb,zb] = ellipsoid(pos_mean(1),pos_mean(2),pos_mean(3),...
        pos_stdev(1)*3,pos_stdev(2)*3,pos_stdev(3)*3);
    mesh(xb,yb,zb,'FaceColor','none');
    plot3(pos_mean(:,1),pos_mean(:,2),pos_mean(:,3),'r+');
end

