function DrawPose(Hp, lw,len, txt)
    H = eye(4);
    if (length(Hp)==3)
        H(1:3,1:3)=Hp;
    elseif (length(Hp)==4)
        H=Hp;
    end
    
    x=H(1:3,1);
    y=H(1:3,2);
    z=H(1:3,3);
    t=H(1:3,4);
    x=[t x*len+t];
    y=[t y*len+t];
    z=[t z*len+t];
    axis('equal');
    hold on;
    plot3(x(1,:),x(2,:),x(3,:),'r','LineWidth',lw);
    plot3(y(1,:),y(2,:),y(3,:),'g','LineWidth',lw);
    plot3(z(1,:),z(2,:),z(3,:),'b','LineWidth',lw);
    text(t(1),t(2),t(3),txt);
end