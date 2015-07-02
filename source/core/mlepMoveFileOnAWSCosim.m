function mlepMoveFileOnAWSCosim(instanceInfo,keyName,rFolder,feed,paraStatus)
%MLEPMOVEFILEONAWSCOSIM This functions moves remote files from the cloud to the
%   out directory
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal
if paraStatus
    if isempty(gcp('nocreate'))
        parpool(instanceInfo.instCount);
    end
end

% Check Folder Name
[a, b, ~] = fileparts(rFolder);
rFolder = [a filesep b];

% Setup Commands
cmd_mkdir = ['mkdir ' rFolder filesep 'out'];
cmd_mv = ['cp ' rFolder filesep '*.mat ' rFolder filesep 'out'];
%cmd_rm = ['rm ' rFolder 'out/*Table.csv ' rFolder 'out/*Meter.csv ' rFolder 'out/*sz.csv'];

% Run Commands for all instances
for i = 1:instanceInfo.instCount
    % Create Dir
    mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd_mkdir, keyName, feed);
    % Copy .mat output to out/
    mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd_mv, keyName, feed);
    % Remove Files
    % mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd_rm, keyName, feed);
end

end

