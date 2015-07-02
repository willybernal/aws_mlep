%%
!synclient HorizTwoFingerScroll=0

%% Parallel Computing Toolbox
% Find command to increase NumWorkers available. (Go to menu Prallel)
paraStatus = false;

%% Create Object
ep = mlepAwsProcess();
% Create EC2 Client
ep.createEC2Client();
% Init EC2 Client
ep.initEC2Client();

%% Init Instances
% % Create Instance if there is no instance on AWS
% numInst = 1;
% typeInst = 't1.micro';
% amiCode = 'ami-b98c77d2';
% % amiCode = 'ami-33aef35a';
% [status, msg, EC2_info] = ep.initAwsInstance(numInst,typeInst,amiCode);

%% Get Info
[status, msg, EC2_info] = ep.getAwsInstanceInfo();

%% Remove Old Files
%Remove old file on AWS
rFolder = '/home/ubuntu/Projects/Supermarket';
ep.removeFolderOnAws(rFolder, false,paraStatus);

%% Push files to EC2
% Push Configuration files to AWS 
lFolder = 'files'; 
ep.pushAllToAWS(lFolder,rFolder,false,paraStatus); 
% Needs time to copy
pause(5);

%% Set GA parameters
popsize = 4;                        % Population Size
numVar = 1;
dimension = 24;                     % Dimension/Number of Variables
bitPerVar = 2;                      % Bits per variable
chromoLen = dimension * bitPerVar;  % Chromosom Length
numGen = 5;                         % Number of Generations
limits = ones(2,dimension);         % Limits for each dimension
Vmax = -10;                         % Max Variable Value
Vmin = -30;                         % Min Variable Value
limits(1,:) = Vmin;                 % Min Value                  
limits(2,:) = Vmax;                 % Max Value
for i = 1:dimension                 % Fields
    fields{i} = ['T' int2str(i)];
end

% Evolution parameters
elitsize = 0.1;                     % Elite Size
pm = 0.05;                          % FIND OUT

%% Allocate Variables
allSchedule = cell(numGen,1);
allData = cell(numGen,1);
allFitness = cell(numGen,1);

%% Generate initial population
pop = genInitPop(popsize,bitPerVar,dimension);
actGen = decodePop(pop,bitPerVar,dimension,limits);

% [oneGen, actGen] = genInitPopulation(popsize,numVar,dimension,bitPerVar,Vmax,Vmin);

%% Create Schedules
writeSchedule(popsize,actGen);

%%
tic 
for i=1:numGen
    disp(['========== GENERATION ' int2str(i) ' =========']);
    % Push Schedule files to AWS 
    lFolder = 'schedule'; 
    ep.pushToAWS(lFolder, rFolder, false,paraStatus); 
    % Needs time to copy
%     pause(3);
    % Run simulation on AWS
    ep.runSimulationOnAWScosim(lFolder, rFolder, false,paraStatus);
    pause(3);
    % Move simulation result to proper folders
    ep.moveFileOnAWSCosim(rFolder, false,paraStatus);
%     pause(3);
    % Fetch simulation result on AWS
    ep.fetchDataOnAWScosim(rFolder,false,paraStatus);
    % Save progress
    allSchedule{i} = pop;
    outFolder = 'Output';
    data = getData(popsize,outFolder);
    allData{i} = data;
    % Evaluate fitness
    [fitness, ~] = calcFitness(data,popsize);
    allFitness{i} = fitness;
    % Select crossover candidates according to fitness
    newPop = gaSelection(pop,fitness,chromoLen,elitsize);
    % Cross Over
    newPop = gaCrossOver(newPop,popsize,bitPerVar,dimension);
    % Mutation
    %  	pop = mutation(newPop, chromoLen);
    pop = gaMutate(newPop,bitPerVar,dimension,pm);
    % Decode
    popDec = decodePop(pop,bitPerVar,dimension,limits);
    % Generate new schedule txt files
    writeSchedule(popsize,popDec);
end
time = toc 
%% Terminate Instances
instanceIds = EC2_info.instanceId;
[status, msg, EC2_info] = ep.terminateAwsInstance(instanceIds);

%%
% Destroy
clear ep;
