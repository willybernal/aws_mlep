function [oneGen, actGen] = genInitPopulation( population, numVar, numStep, rangeBit,Vmax,Vmin)
%GENINITPOPULATION This function generates a random schedules for the first 
% generation and writes them into text files
%
%   INPUT
%   population      number of individuals in each generation    
%   numVar          number of knobs in each schedule
%   numStep         number of time steps in each schedule 
%   rangeBit        number of bits used to represent a variable
%   offset          offset given to each numVar, used to control the range
%                   of the value of each knob
%   OUTPUT
%   oneGen          contains the (encoded) schedule info in one generation
%
%   Created by Tao Lei(leitao@seas.upenn.edu) Oct 2013

% Generate Chromosomes
for i = 1:population
    % Generate Random integer data 
    data = genParameters(numVar,numStep,rangeBit);
    % Generate Chromosomes
    strChromos = encodeChromosomes(data,rangeBit);
    % Generate String of chromosoms
    oneGen(i,:) = bin2dec(strChromos); 
end

% Generate Actual Values
for i = 1:population
    actGen(i,:) = (Vmax-Vmin)/(2^rangeBit-1)*oneGen(i,:) + Vmin;
end

% Write Schedule
if exist('schedule', 'dir')
    rmdir('schedule', 's');
end
mkdir('schedule');
for i = 1:population
    % Create filename
    filename = strcat(num2str(i),'.txt');
    % Write all schedule files
    dlmwrite(strcat('schedule/',filename),actGen(i,:),'-append');
end

