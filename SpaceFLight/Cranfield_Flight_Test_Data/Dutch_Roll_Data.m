close all 
clear
clc


%% Cranfeild Data - Dutch Roll Group A

data1 = xlsread('Dutch-Roll_GpA.xls');

time = data1(:,1);
Rud = data1(:,2);
Beta = data1(:,3);
Yaw_rate = data1(:,4);
Roll_Rate = data1(:,5);
Lat_Acc = data1(:,6);
Roll_An = data1(:,7);
TAS = data1(:,8);


figure(1) 
subplot(2,3,1)
plot(time,Rud,'r')
grid on

subplot(2,3,2)
plot(time,Beta,'r')
grid on

subplot(2,3,3)
plot(time,Yaw_rate,'r')
grid on

subplot(2,3,4)
plot(time,Roll_Rate,'r')
grid on

subplot(2,3,5)
plot(time,Lat_Acc,'r')
grid on

subplot(2,3,6)
plot(time,Roll_An,'r')
grid on

% subplot(2,3,7)
% plot(time,TAS,'r')
% grid on

%% Cranfeild Data - Dutch Roll Group B

data2 = xlsread('Dutch-Roll_GpB.xls');

time = data2(:,1);
Rud = data2(:,2);
Beta = data2(:,3);
Yaw_rate = data2(:,4);
Roll_Rate = data2(:,5);
Lat_Acc = data2(:,6);
Roll_An = data2(:,7);
TAS = data2(:,8);

figure(2) 
subplot(2,3,1)
plot(time,Rud,'b')
grid on

subplot(2,3,2)
plot(time,Beta,'b')
grid on

subplot(2,3,3)
plot(time,Yaw_rate,'b')
grid on

subplot(2,3,4)
plot(time,Roll_Rate,'b')
grid on

subplot(2,3,5)
plot(time,Lat_Acc,'b')
grid on

subplot(2,3,6)
plot(time,Roll_An,'b')
grid on

% subplot(2,3,7)
% plot(time,TAS,'b')
% grid on

%% Cranfeild Data - Dutch Roll Group C

data3 = xlsread('Dutch-Roll_GpC.xls');

time = data3(:,1);
Rud = data3(:,2);
Beta = data3(:,3);
Yaw_rate = data3(:,4);
Roll_Rate = data3(:,5);
Lat_Acc = data3(:,6);
Roll_An = data3(:,7);
TAS = data3(:,8);

figure(3) 
subplot(2,3,1)
plot(time,Rud,'k')
grid on

subplot(2,3,2)
plot(time,Beta,'k')
grid on

subplot(2,3,3)
plot(time,Yaw_rate,'k')
grid on

subplot(2,3,4)
plot(time,Roll_Rate,'k')
grid on

subplot(2,3,5)
plot(time,Lat_Acc,'k')
grid on

subplot(2,3,6)
plot(time,Roll_An,'k')
grid on

% subplot(2,3,7)
% plot(time,TAS,'k')
% grid on
