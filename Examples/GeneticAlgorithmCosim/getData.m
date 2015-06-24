function [data] = getData(popsize,outFolder)

% Allocate Output Variable
load(['.' filesep outFolder filesep int2str(1) '.mat']);
data = zeros(length(rt_tout),popsize+1);

% Save Time 
data(:,end) = rt_tout;

% Load Data from .mat files
for i = 1:popsize
    load(['.' filesep outFolder filesep int2str(i) '.mat']);
    data(:,i) = rt_yout(:,1);
end








