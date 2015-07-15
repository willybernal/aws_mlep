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
pause(2);

load('super.mat');
y = sum(rt_yout(:,1))

% Come back
cd(direc);
