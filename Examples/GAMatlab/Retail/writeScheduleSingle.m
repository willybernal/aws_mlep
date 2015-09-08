function [] = writeScheduleSingle(input)

% Set format
input_vec = zeros(2,24);
var = [3 3 2 2 2 2 2 2];
default_rem = 24-sum(var);
defa_sp(1,1:default_rem) = -24*ones(1,default_rem);
defa_sp(2,1:default_rem) = 24*ones(1,default_rem);
cumsum_var = cumsum(var);
start = 1;

% Expand 
for i = 1:length(input)/2
    input_vec(1,start:cumsum_var(i)) = input(i);
    input_vec(2,start:cumsum_var(i)) = input(length(input)/2+i);
    start = cumsum_var(i) + 1;
end
input_vec(:,start:end) = defa_sp;

% Write Schedules
dlmwrite('Supermarket/input.txt',input_vec(1,:));
dlmwrite('Supermarket/hvac_input.txt',input_vec(2,:));
