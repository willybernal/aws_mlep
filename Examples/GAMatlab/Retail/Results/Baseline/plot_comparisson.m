% Script for plotting comparisson between optimized and non-optimized

%% Load results
output_bas = load('retail_store_bas_ref.mat');

%% Setpoints - baseline for 2 days
set(gca,'FontSize',24);
figure(1);
a = output_bas.rt_yout(:,17);
a(a==30) = 14;
a(a==24) = 20;
x = output_bas.rt_tout/3600;
plot(x,output_bas.rt_yout(:,17),'b',x,a,'r',x,output_bas.rt_yout(:,11),'g',x,output_bas.rt_yout(:,12),'m',x,output_bas.rt_yout(:,13),'k',x,output_bas.rt_yout(:,15),'c');
% title('');
xlabel('Hour','FontSize',24);
ylabel('Temperature [C]');
legend('CSP','HSP','Core','Back','Sale','Front');
grid on;

%% Fan DX Consumption
figure(2);
subplot(2,1,1);plot(x,output_bas.rt_yout(:,19)/1000,'g',x,output_bas.rt_yout(:,18)/1000,'m',x,output_bas.rt_yout(:,20)/1000,'k',x,output_bas.rt_yout(:,21)/1000,'c');
title('Fan');
xlabel('Hour');
ylabel('Power [kW]');
legend('Core','Back','Sale','Front');
grid on;
subplot(2,1,2);plot(x,output_bas.rt_yout(:,23)/1000,'g',x,output_bas.rt_yout(:,22)/1000,'m',x,output_bas.rt_yout(:,24)/1000,'k',x,output_bas.rt_yout(:,25)/1000,'c');
title('DX Cooling Coil');
xlabel('Hour');
ylabel('Power [kW]');
legend('Core','Back','Sale','Front');
grid on;

%% Power Consumption
figure(3);plot(x,output_bas.rt_yout(:,1)/1000,'k',x,output_bas.rt_yout(:,2)/1000,'b',x,output_bas.rt_yout(:,3)/1000,'r',x,output_bas.rt_yout(:,4)/1000+output_bas.rt_yout(:,7)/1000,'m');
xlabel('Hour');
ylabel('Power [kW]');
legend('Total','Building','HVAC','Refrigeration');
grid on;

%% Power Consumption
figure(4);
x = output_bas.rt_tout/3600;
plot(x,output_bas.rt_yout(:,1)/1000,'r*-',x,output_opt.rt_yout(:,1)/1000,'b^-');
vline([13 17],'k');
title('Total Power');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
plot(x,output_bas.rt_yout(:,3)/1000,'r*-',x,output_opt.rt_yout(:,3)/1000,'b^-');
vline([13 17],'k');
title('HVAC');
xlabel('Hour');
ylabel('Power [kW]');
% axis([0 25 -26 -6]);
grid on;
legend('Baseline','Optimized');
plot(x,output_bas.rt_yout(:,4)/1000+output_bas.rt_yout(:,7)/1000,'r*-',x,output_opt.rt_yout(:,4)/1000+output_opt.rt_yout(:,7)/1000,'b^-');
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
plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,5),'r*-',x,output_opt.rt_yout(:,6),'b^-');
vline([13 17],'k');
title('Case');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
plot(x,output_opt.rt_yout(:,10),'k--',x,output_opt.rt_yout(:,8),'r*-',x,output_opt.rt_yout(:,9),'b^-');
vline([13 17],'k');
title('Walk-In');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Product','Case');
plot(x,output_opt.rt_yout(:,17),'k--',x,output_opt.rt_yout(:,11),'r*-',x,output_opt.rt_yout(:,12),'b^-',x,output_opt.rt_yout(:,13),'m^-',x,output_opt.rt_yout(:,14),'c^-',x,output_opt.rt_yout(:,15),'g^-');
vline([13 17],'k');
title('HVAC');
xlabel('Hour');
ylabel('Temperature [C]');
grid on;
legend('SP','Refrigeraton','Back','Core','Entry','Front');

