function [c, ceq] = calculate_constraint(input)
rFolder = 'Supermarket';

% Change Dir
fullname = mfilename('fullpath');
[direc, ~, ~ ]= fileparts(fullname);
cd(rFolder);

% Simulate
cmd = ['./super'];
system(cmd);
pause(2);

load('super.mat');
tprod = rt_yout(:,7);


% Come back
cd(direc);

c = [max(tprod)+10;
    -min(tprod)-30];

ceq = [];


