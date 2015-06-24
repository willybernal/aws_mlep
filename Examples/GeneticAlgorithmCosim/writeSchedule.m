function [] = writeSchedule(population,actGen)

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
