close all
clear
clc

%% Cranfield Test Data - Phugoid Group A  

data1 = xlsread('Phugoid_GpA.xls')

time = data1(:,1);
El = data1(:,2);
Pit = data1(:,3);
u = data1(:,4);
Al = data1(:,5);

figure(1) 
subplot(2,2,1)
plot(time,El,'k')
% [pk, lc] = findpeaks(El,time);
% [troughs, lc1] = findpeaks(-El,time);
% troughs = -troughs;
% plot(time,El,lc, pk,'bo')
% hold on
% plot(time,El,lc1, troughs, 'bo')
title('Elevator Deflection Vs Time')
xlabel('Time (s)')
ylabel('Elevator (Rads)')
grid on

subplot(2,2,2)
[pk, lc] = findpeaks(Pit,time);
[troughs, lc1] = findpeaks(-Pit,time);
troughs = -troughs;
plot(time,Pit,lc, pk,'ko')
hold on
plot(time,Pit,lc1, troughs, 'ko')
% plot(time,El,'b')
title('Pitch Angle Vs Time')
xlabel('Time (s)')
ylabel('Pitch (Rads)')
grid on

subplot(2,2,3)
% plot(time,u,'k')
[pk, lc] = findpeaks(u,time);
[troughs, lc1] = findpeaks(-u,time);
troughs = -troughs;
plot(time,u,lc, pk,'ko')
hold on
plot(time,u,lc1, troughs, 'ko')
title('Speed Vs Time')
xlabel('Time (s)')
ylabel('Speed (Knots)')
grid on

subplot(2,2,4)
% plot(time,Al,'y')
[pk, lc] = findpeaks(Al,time);
[troughs, lc1] = findpeaks(-Al,time);
troughs = -troughs;
plot(time,Al,lc, pk,'ko')
hold on
plot(time,Al,lc1, troughs, 'ko')
title('Altitude Vs Time')
xlabel('Time (s)')
ylabel('Altitude (ft)')
grid on

%% Cranfield Test Data - Phugoid Group B 


data2 = xlsread('Phugoid_GpB.xls')

time = data2(:,1);
El = data2(:,2);
Pit = data2(:,3);
u = data2(:,4);
Al = data2(:,5);

figure(1) 
subplot(2,2,1)
plot(time,El,'m')
% [pk, lc] = findpeaks(El,time);
% [troughs, lc1] = findpeaks(-El,time);
% troughs = -troughs;
% plot(time,El,lc, pk,'bo')
% hold on
% plot(time,El,lc1, troughs, 'bo')
title('Elevator Deflection Vs Time')
xlabel('Time (s)')
ylabel('Elevator (Rads)')
grid on

subplot(2,2,2)
[pk, lc] = findpeaks(Pit,time);
[troughs, lc1] = findpeaks(-Pit,time);
troughs = -troughs;
plot(time,Pit,lc, pk,'mo')
hold on
plot(time,Pit,lc1, troughs, 'mo')
% plot(time,El,'b')
title('Pitch Angle Vs Time')
xlabel('Time (s)')
ylabel('Pitch (Rads)')
grid on

subplot(2,2,3)
% plot(time,u,'k')
[pk, lc] = findpeaks(u,time);
[troughs, lc1] = findpeaks(-u,time);
troughs = -troughs;
plot(time,u,lc, pk,'mo')
hold on
plot(time,u,lc1, troughs, 'mo')
title('Speed Vs Time')
xlabel('Time (s)')
ylabel('Speed (Knots)')
grid on

subplot(2,2,4)
% plot(time,Al,'y')
[pk, lc] = findpeaks(Al,time);
[troughs, lc1] = findpeaks(-Al,time);
troughs = -troughs;
plot(time,Al,lc, pk,'mo')
hold on
plot(time,Al,lc1, troughs, 'mo')
title('Altitude Vs Time')
xlabel('Time (s)')
ylabel('Altitude (ft)')
grid on


%% %% Cranfield Test Data - Phugoid Group C 


data3 = xlsread('Phugoid_GpC.xls')

time = data3(:,1);
El = data3(:,2);
Pit = data3(:,3);
u = data3(:,4);
Al = data3(:,5);

figure(1) 
subplot(2,2,1)
plot(time,El,'r')
% [pk, lc] = findpeaks(El,time);
% [troughs, lc1] = findpeaks(-El,time);
% troughs = -troughs;
% plot(time,El,lc, pk,'bo')
% hold on
% plot(time,El,lc1, troughs, 'bo')
title('Elevator Deflection Vs Time')
xlabel('Time (s)')
ylabel('Elevator (Rads)')
grid on

subplot(2,2,2)
[pk, lc] = findpeaks(Pit,time);
[troughs, lc1] = findpeaks(-Pit,time);
troughs = -troughs;
plot(time,Pit,lc, pk,'ro')
hold on
plot(time,Pit,lc1, troughs, 'ro')
% plot(time,El,'b')
title('Pitch Angle Vs Time')
xlabel('Time (s)')
ylabel('Pitch (Rads)')
grid on

subplot(2,2,3)
% plot(time,u,'k')
[pk, lc] = findpeaks(u,time);
[troughs, lc1] = findpeaks(-u,time);
troughs = -troughs;
plot(time,u,lc, pk,'ro')
hold on
plot(time,u,lc1, troughs, 'ro')
title('Speed Vs Time')
xlabel('Time (s)')
ylabel('Speed (Knots)')
grid on

subplot(2,2,4)
% plot(time,Al,'y')
[pk, lc] = findpeaks(Al,time);
[troughs, lc1] = findpeaks(-Al,time);
troughs = -troughs;
plot(time,Al,lc, pk,'ro')
hold on
plot(time,Al,lc1, troughs, 'ro')
title('Altitude Vs Time')
xlabel('Time (s)')
ylabel('Altitude (ft)')
grid on


