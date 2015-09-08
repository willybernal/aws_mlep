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
pause(3);

% Get Fitness
% read result1 or result2
val1 = textread('result1.txt','%f');
val2 = textread('result2.txt','%f');
y = val1+val2;

% Come back
cd(direc);
