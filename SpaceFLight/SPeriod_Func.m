function SPeriod_Func()

data = xlsread('SPPO_GpA');

 t = data(:,1);
 q = data(:,5);
 theta = data(:,2);
 
 figure(1)
 hold on
 subplot(2,1,1)
 plot(t,q)
 subplot(2,1,2)
 plot(t,theta)
 hold off
 
 U0 = data(1,4);
% Q = 0.5*Rho*(U0^2)
% Rho = 1.225?
S = 25.083;
cbar = 1.717;
% Iy =
% Clalpha = -0.1715?
% Cd0 = -0.1715?
% m =
% Cmq =
% Malphadot = 
 Mw = (Cmalpha*Q*S*cbar)/(U0*Iy);
 Zw = -(((Clalpha+Cd0)*Q*S)/(U0*m));
 Malpha = U0*Mw;
 Zalpha = U0*Zw;
 Mq = (Cmq*(cbar/2*U0)*Q*S*cbar)/(U0*Iy);
 
 Omeg_nsp = sqrt((Zalpha*Mq/U0)-Malpha);
 Zeta_sp = -((Mq+Malphadot+(Zalpha/U0))/(2*Omeg_nsp));
 
 

end

