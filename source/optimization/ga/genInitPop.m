function pop=genInitPop(popsize,stringlength,dimension)
%GENINITPOP Generates a random population according to the input parameters
% Inputs:
%   popsize - Population dimension
%   stringlength - bits per variable. e.g. 4bits 0101
%   dimensions - number per variables. e.g. 2 for 2 variables to optimize. 
% Outputs: 
%   pop - binary population 
% 

% Generate Initial Population
% Contains extra row for fitness
pop=round(rand(popsize,dimension*stringlength));