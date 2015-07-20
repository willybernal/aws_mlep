function [] = writeScheduleSingle(input)

% Write all schedule files
%     dlmwrite(strcat('schedule/',filename),[-20*ones(1,12),actGen(i,:),-20*ones(1,4)]);
dlmwrite('Supermarket/input.txt',input);
