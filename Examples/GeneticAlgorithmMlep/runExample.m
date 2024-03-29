% This script retrieves EC2 information from your AWS account. Copies the 
% basic files in the "files" folder to the instances, copies the input text 
% files and then runs the simulations, retrieves the results back to the 
% local computer. Finally, it loads the results and plots the data. 
%
% This script illustrates the usage of class mlepAwsProcess in the MLE+
% toolbox. 
%
% This script is free software.
%
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)
%
% CHANGES:
%   2013-09-11  Created. 

clc;
tic 
%% Create an mlepAwsProcess instance and configure it
ep = mlepAwsProcess();
% Create EC2 Client
ep.createEC2Client();
% Init EC2 Client
ep.initEC2Client();
% Get Current instances Info
ep.getAwsInstanceInfo(); 
%Remove old file on AWS
rFolder = '/home/ubuntu/simulation/';
ep.removeFolderOnAws(rFolder, false);

%% Push Configuration files to EC2
% Push Configuration files to AWS 
lFolder = 'files'; 
ep.pushAllToAWS(lFolder, rFolder, false); 
% Needs time to copy
pause(10);

%% Set GA parameters
popsize = 24;
numVar = 1;
dimension = 10;
bitPerVar = 4;
offset = 21;
chromoLen = numVar * bitPerVar;

numGen = 20;



%% Generate Initial Generation
% Generate initial population
pop = genInitScheduleTXT(popsize,numVar,dimension,bitPerVar,offset);


%% GENERATIONS
for i=1:numGen
    i
    % Push Schedule files to AWS 
    lFolder = 'schedule'; 
    ep.pushToAWS(lFolder, rFolder, false); 
    % Needs time to copy
    pause(4);
    % Run simulation on AWS
    ep.runSimulationOnAWSmlep(lFolder, rFolder, false);
    % Move simulation result to proper folders
    ep.moveFileOnAWS(rFolder, true);
    pause(2);
    % Fetch simulation result on AWS
    ep.fetchDataOnAWS(rFolder);
    while(~(size(dir('OutputCSV'),1) == (popsize + 2)))
        disp('waiting for results');
    end
    % Load Data
    csvData = loadCSVs('OutputCSV');
    data = cell2mat(csvData.data);
    % Save progress
    allSchedule{i} = pop;
    allData{i} = data;
    save schedule allSchedule;
    save data allData;
    % Evaluate fitness
    fitness = getFitness(data(33:72,7:8:end), data(33:68,8:8:end));
    % Select crossover candidates according to fitness
    sel = selection(fitness,popsize);   
    % Cross Over
    recombinedChromosomes = recombinationaAll(pop(sel,:), chromoLen,bitPerVar);
    % Mutation
 	pop = mutation(recombinedChromosomes, chromoLen);
    % Generate new schedule txt files
    genTXTSchedule(pop, chromoLen, bitPerVar, offset);
end

% Plot Progress
toc

