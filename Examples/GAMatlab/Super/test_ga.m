%% Prepare Directory
%Remove old file on AWS
rFolder = './Supermarket';
system(['rm -r ' rFolder]);
system(['mkdir ' rFolder]);

%% Push files to EC2
% Push Configuration files to AWS 
lFolder = 'files'; 
system(['cp -r ' lFolder  filesep '* ' rFolder]);

%% GA
ObjectiveFunction = @calculate_fitness;
nvars = 24;    % Number of variables

ConstraintFunction = @calculate_constraint;
% Constraint input
low = -25*-1*ones(nvars,1);
high = -15*ones(nvars,1);
I = eye(nvars);
A = [I;-I];
b = [high;low];
LB = -25*ones(1,nvars);   % Lower bound
UB = -15*ones(1,nvars);  % Upper bound

% 'MutationFcn',@mutationadaptfeasible;
popsize = 20;
elite = ceil(0.2*popsize);
numgen = 5;
tic
options = gaoptimset('OutputFcns',@savePop,'PopulationSize',popsize,'Generations',numgen,'PlotFcns',{@gaplotbestf},'Display','iter');
[x,fval,exit_flag,output,population,scores] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,[],options); %  ConstraintFunction
toc 

