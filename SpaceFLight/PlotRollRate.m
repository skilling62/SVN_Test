% Script to Compare the Roll mode of the model with that of the flight test
% aircraft

clc

global time_
rt = time_ - 0.1;

global RollRate_
rollrate = RollRate_ - 20;

length(rt);
length(rollrate);

plot(simout1.time, simout1.signals.values,'DisplayName','Linearized Aircraft Model')
hold on
plot (rt, rollrate,'DisplayName','Flight Test Data')
hold off
axis tight
grid minor
legend(gca,'show')
xlabel('Time (Seconds)')
ylabel('Aircraft Roll Rate (degrees/s)')