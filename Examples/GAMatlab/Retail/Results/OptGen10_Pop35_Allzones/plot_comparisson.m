% Script for plotting comparisson between optimized and non-optimized

%% Load results
output_bas = load('retail_store_bas2.mat');
output_opt = load('retail_store_opt.mat');
output_bil = load('opt_bill.mat');

%% Setpoints
figure(1);
x = output_bas.rt_tout/3600;
subplot(2,1,1);plot(x,output_bas.rt_yout(:,10),'r',x,output_opt.rt_yout(:,10),'b--');
vline([12 16],'k--');
title('Refrigeration SP');
xlabel('Hour');
ylabel('Temperature [C]');
legend('Baseline','Optimized');
grid on;
subplot(2,1,2);plot(x,output_bas.rt_yout(:,17),'r',x,output_opt.rt_yout(:,17),'b--');
vline([12 16],'k--');
title('HVAC SP');
xlabel('Hour');
ylabel('Temperature [C]');
legend('Baseline','Optimized');
grid on;

%% Power Consumption
figure(2);
x = output_bas.rt_tout/3600;
subplot(3,1,1);plot(x,output_bas.rt_yout(:,1)/1000,'r',x,output_opt.rt_yout(:,1)/1000,'b');
vline([12 16],'k--');
title('Total Power');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
subplot(3,1,2);plot(x,output_bas.rt_yout(:,3)/1000,'r',x,output_opt.rt_yout(:,3)/1000,'b');
vline([12 16],'k--');
title('HVAC');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
subplot(3,1,3);plot(x,output_bas.rt_yout(:,4)/1000+output_bas.rt_yout(:,7)/1000,'r',x,output_opt.rt_yout(:,4)/1000+output_opt.rt_yout(:,7)/1000,'b');
vline([12 16],'k--');
title('Refrigeration');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');

%% Temperature
figure(3);
x = output_bas.rt_tout/3600;
subplot(3,1,1);plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,5),'r',x,output_opt.rt_yout(:,6),'b');
vline([12 16],'k--');
title('Case');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
subplot(3,1,2);plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,8),'r',x,output_opt.rt_yout(:,9),'b');
vline([12 16],'k--');
title('Walk-In');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
subplot(3,1,3);plot(x,output_opt.rt_yout(:,16),'b',x,output_bas.rt_yout(:,16),'r');
vline([12 16],'k--');
title('Sensible Heat');
xlabel('Hour');
ylabel('Heat [W]');
grid on;
legend('Optimized','Baseline');

%% 
figure(4);
plot(x,output_opt.rt_yout(:,26),'m',x,output_opt.rt_yout(:,11),'b',x,output_bas.rt_yout(:,11),'r');
vline([12 16],'k--');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('Outdoor','Optimized','Baseline');

%% Bill
figure(5);
x = output_bil.ans.Time/3600;
plot(x,output_bil.ans.Data(:,1),'r',x,output_bil.ans.Data(:,2),'b');
vline([12 16],'k--');
title('HVAC');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('Energy Consumption','DR Penalty');
