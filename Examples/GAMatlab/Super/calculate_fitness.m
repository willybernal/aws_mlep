function y = calculate_fitness(input)

rFolder = 'Supermarket';

%% Create Schedules
writeScheduleSingle(input);

% Change Dir
fullname = mfilename('fullpath');
[direc, ~, ~ ]= fileparts(fullname);
cd(rFolder);

% Simulate
cmd = ['./super'];
system(cmd);
pause(1.2);

load('super.mat');
a = rt_yout(:,1);
% y = sum(a);
load('./../Pricing/dr_price_201505_hgload.mat')
ind = mean(a(tariff==1));
z = sum(a);    
y = abs(ind - 4*10^5);

% Come back
cd(direc);
