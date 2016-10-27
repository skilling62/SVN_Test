clear all
clc

Data = xlsread('SPPO_GpA');

t = Data(:,1);
q = Data(:,5);
delta_e = Data(:,2);

figure(1)
plot(t,q,'k',t,delta_e,'b')
axis([4,16,-11,11]);
grid on

A_SP= [ Zw,                 u0, ...
        Mw + (Mw_dot*Zw),   Mq + Mw_dot*u0,]



% figure(1)
% hold on
% subplot(2,1,1)
% plot(t,q);
% grid on
% axis([5,8,-9,12])
% title('Time Vs Pitch Rate'); xlabel('Time (s)'); ylabel('Pitch Rate (rads)');
% subplot(2,1,2)
% plot(t,delta_e);
% grid on
% axis([5,8,-9,12])
% title('Time Vs Delta E'); xlabel('Time (s)'); ylabel('Delat E (rads)');
% hold off


% [pks, locs] = findpeaks(w,t);
