function DrawAxis(C, lw, txt)
%DrawAxis Draw X Y Z coordinates in red green blue color
%   DrawAxis(C,lineWidth,text)
%   C=4x4 matrix
%     column1 is origin position
%     column2 is x vector
%     column3 is y vector
%     column4 is z vector
    plot3([C(1,1) C(1,2)],[C(2,1) C(2,2)] ,[C(3,1), C(3,2)],'r','LineWidth',lw);
    plot3([C(1,1) C(1,3)],[C(2,1) C(2,3)] ,[C(3,1), C(3,3)],'g','LineWidth',lw);
    plot3([C(1,1) C(1,4)],[C(2,1) C(2,4)] ,[C(3,1), C(3,4)],'b','LineWidth',lw);
    text(C(1,1),C(2,1),C(3,1),txt);
end