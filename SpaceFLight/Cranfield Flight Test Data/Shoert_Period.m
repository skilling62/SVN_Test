
data = xlsread('');

kts2ms = 0.51444 % kts to m/s 1 = 0.51444

time = data(:,1);
speed = data(:,4) * kts2ms; 


[pk,lc] = findpeaks(speed,time);
[troughs, lc1] = findpeaks(-speed,time);
troughs = -troughs;
plot(time,speed, 'g',lc, pk, 'mo', lc1, troughs, 'ko');
ax.XTickLabelMode = 'auto';
grid minor;