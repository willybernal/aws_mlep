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
nvars = 16;    % Number of variables

ConstraintFunction = @calculate_constraint;
% Constraint input
low = -24*-1*ones(nvars,1);
high = -8*ones(nvars,1);
I = eye(nvars);
A = [I;-I];
b = [high;low];
LB = [-24 -24 -24 -24 -24 -24 -24 -24 21 21 21 21 21 21 21 21]; % Lower bound
UB = [-8  -8  -8  -8  -8  -8  -8  -8  24 24 24 24 24 24 24 24]; % Upper bound

% 'MutationFcn',@mutationadaptfeasible;
popsize = 35;
elite = ceil(0.1*popsize);
numgen = 15;

tic
options = gaoptimset('OutputFcns',@savePop,'PopulationSize',popsize,'Generations',numgen,'PlotFcns',{@gaplotbestf},'Display','iter');
[x,fval,exit_flag,output,population,scores] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,[],options); %  ConstraintFunction
toc 

save('ga_output.mat','x','fval','exit_flag','output','population','scores');
