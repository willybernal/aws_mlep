% Script for plotting comparisson between optimized and non-optimized

%% Load results
output_bas = load('retail_store_bas.mat');
output_opt = load('retail_store_opt.mat');
input_bas = load('input_bas.mat');
input_opt = load('input_opt.mat');

%% Setpoints
figure(1);
x = output_bas.rt_tout/3600;
subplot(2,1,1);plot(x,output_bas.rt_yout(:,10),'r',x,output_opt.rt_yout(:,10),'b--');
vline([13 17],'k');
title('Refrigeration SP');
xlabel('Hour');
ylabel('Temperature [C]');
legend('Baseline','Optimized');
grid on;
subplot(2,1,2);plot(x,output_bas.rt_yout(:,17),'r',x,output_opt.rt_yout(:,17),'b--');
vline([13 17],'k');
title('HVAC SP');
xlabel('Hour');
ylabel('Temperature [C]');
legend('Baseline','Optimized');
grid on;

%% Power Consumption
figure(2);
x = output_bas.rt_tout/3600;
subplot(3,1,1);plot(x,output_bas.rt_yout(:,1)/1000,'r*-',x,output_opt.rt_yout(:,1)/1000,'b^-');
vline([13 17],'k');
title('Total Power');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
subplot(3,1,2);plot(x,output_bas.rt_yout(:,3)/1000,'r*-',x,output_opt.rt_yout(:,3)/1000,'b^-');
vline([13 17],'k');
title('HVAC');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
subplot(3,1,3);plot(x,output_bas.rt_yout(:,4)/1000+output_bas.rt_yout(:,7)/1000,'r*-',x,output_opt.rt_yout(:,4)/1000+output_opt.rt_yout(:,7)/1000,'b^-');
vline([13 17],'k');
title('Refrigeration');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');

%% Temperature
figure(3);
x = output_bas.rt_tout/3600;
subplot(3,1,1);plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,5),'r*-',x,output_opt.rt_yout(:,6),'b^-');
vline([13 17],'k');
title('Case');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
subplot(3,1,2);plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,8),'r*-',x,output_opt.rt_yout(:,9),'b^-');
vline([13 17],'k');
title('Walk-In');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
subplot(3,1,3);plot(x,output_opt.rt_yout(:,17),'k--',x,output_opt.rt_yout(:,11),'r*-',x,output_opt.rt_yout(:,12),'b^-',x,output_opt.rt_yout(:,13),'m^-',x,output_opt.rt_yout(:,14),'c^-',x,output_opt.rt_yout(:,15),'g^-');
vline([13 17],'k');
title('HVAC');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Refrigeraton','Back','Core','Entry','Front');

