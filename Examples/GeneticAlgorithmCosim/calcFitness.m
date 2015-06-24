function [fitness, fitnessRaw] = calcFitness(data,popsize)
%   Function to get the fitness of each individual within an population in one generation
%   INPUT    delayRecPerGen     The delay of each individual in the population
%            expect             The expected result? or the expected total delay                  
%   OUTPUT   fitness            Each individual's fitness
%   Created by Tao Lei (leitao@seas.upenn.edu) Sep 2013

% Initialize variable
fitness = zeros(popsize,1);

% Find Mean for each individual
for i = 1:popsize
    fitness(i) = sum(data(:,1));
end

% Resize for finer granularity
minV = min(fitness);
maxV = max(fitness);
fitnessRaw = fitness;
% fitness = (maxV - fitness) + (maxV-minV)*0.1;


% popsize = length(fitness);
% if sum(fitness == 0) == popsize
%     fitness = 1/popsize*ones(1,popsize);
% end

% Rank
[order, ind] = sort(fitness);
fitnessRank = ind;
fitnessRank = 1./fitnessRank;
fitnessRank = fitness/sum(fitnessRank);




