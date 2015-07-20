function [c, ceq] = calculate_constraint(input)
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
pause(1);

load('super.mat');
tprod = rt_yout(:,6);


% Come back
cd(direc);

c = [max(tprod)+10;
    -min(tprod)-30];

ceq = [];


