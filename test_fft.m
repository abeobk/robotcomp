%load data file
[~,~,data]=xlsread('D:/phase.csv');
Y=cell2mat(data);
% Y=Y(30:212);
%sampling frequency
f=length(Y);
% period
T=1/f;
%length of data
L=length(Y);
% time
t=(0:L-1)*T;

%FFT
FY=fft(Y);



%mag
P2=abs(FY/L);
%take half
P1=P2(1:L/2+1);
% rearrange
P1(2:end-1) = 2*P1(2:end-1);

F=f*(0:(L/2))/L;
figure;
smooth(P1,21);
plot(F,P1)


%smooth clear high frequency
sf = 1;
FY(sf:end)=smooth(FY(sf:end),3);

YC = abs(ifft(FY));
figure;
hold on;
plot(X,Y);
plot(X,YC);
figure;
plot(X,FY);