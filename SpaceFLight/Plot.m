% Script to Compare the Phugoid model with the Phugoid Flight Test
clc

global time
t = time;
global U
speed = U - U(1);

plot(simout.time, simout.signals.values,'DisplayName','Linearized Aircraft Model')
hold on
plot (t, speed,'DisplayName','Flight Test Data')
hold off 
grid minor
legend(gca,'show')
xlabel('Time (Seconds)')
ylabel('Aircraft Velocity (m/s)')

% Analysing the plot. The phugoid response is way too heavily damped and the frequency is too low
% According to Nelson p162 this is because the Xu is too big (Xu increases
% damping) or Zu is too small (increasing Zu increases the frequency)
