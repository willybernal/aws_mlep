%%
!synclient HorizTwoFingerScroll=0

%% Remove Old Files
%Remove old file on AWS
rFolder = './Supermarket';
system(['rm -r ' rFolder]);
system(['mkdir ' rFolder]);

%% Push files to EC2
% Push Configuration files to AWS 
lFolder = 'files'; 
system(['cp -r ' lFolder  filesep '* ' rFolder]);

% mv files
cmd = ['mkdir ' rFolder filesep 'out'];
system(cmd);

%% Set GA parameters
popsize = 4;                        % Population Size
numVar = 1;
dimension = 8;                     % Dimension/Number of Variables
bitPerVar = 2;                      % Bits per variable
chromoLen = dimension * bitPerVar;  % Chromosom Length
numGen = 5;                         % Number of Generations
limits = ones(2,dimension);         % Limits for each dimension
Vmax = -15;                         % Max Variable Value
Vmin = -25;                         % Min Variable Value
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
popDec = decodePop(pop,bitPerVar,dimension,limits);
figure(1);plot(popDec');
% [oneGen, popDec] = genInitPopulation(popsize,numVar,dimension,bitPerVar,Vmax,Vmin);

%% Create Schedules
writeSchedule(popsize,popDec);

%%
t1 = tic; 
for i=1:numGen
    t2 = tic;
    disp(['========== GENERATION ' int2str(i) ' =========']);
    % Push Schedule files to AWS 
    lFolder = 'schedule'; 
    system(['cp ' lFolder filesep '* ' rFolder]);
    % Run simulation on AWS
    % Move simulation result to proper folders
    % Fetch simulation result on AWS
    for j = 1:popsize
        cmd = ['mv ' rFolder filesep int2str(j) '.txt ' rFolder filesep 'input.txt'];
        system(cmd);
        pause(2);
        
        % Change Dir
        fullname = mfilename('fullpath');
        [direc, ~, ~ ]= fileparts(fullname);
        cd(rFolder);
        
        % Simulate
        cmd = ['./super'];
        system(cmd);
        cd(direc);
                
        % Copy 
        cmd = ['mv ' rFolder filesep 'super.mat ' rFolder filesep 'out' filesep int2str(j) '.mat'];
        system(cmd);
    end
    % Save progress
    allSchedule{i} = pop;
    outFolder = [rFolder filesep 'out'];
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
    % Print Population
    figure(1);plot(popDec');
    toc(t2);
end
toc(t1); 
%% Show Generation Progress

