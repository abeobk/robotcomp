Hpc=[0.9284865237860056, 0.05472758965007062, -0.3673114020539965, 276.6243918382318; 0.00336190665905222, 0.9878024659764055, 0.1556758998514155, 4.694478713079008; 0.3713508754956625, -0.1457778417388103, 0.9169772887735984, 2.165654602723976; 0, 0, 0, 1]
Hview=[0.9955428839920435, 0.001889038950058961, 0.09429102642695983, -137.8022573408473; 0.001889038950058961, 0.9991993773219118, -0.03996293146590836, -2.56336427560541; -0.09429102642695981, 0.03996293146590835, 0.9947422613139554, 11.87066227667142; 0, 0, 0, 1]
Hc=eye(4);
close all;
axis([-400 400 -400 400 -400 400])

z=[ 0 0 1]';


DrawPose(Hc,1,100,'Hc')
DrawPose(Hpc,1,100,'Hpc')
DrawPose(Hview,1,100,'Hview')
DrawPose(inv(Hview),1,100,'Hv')