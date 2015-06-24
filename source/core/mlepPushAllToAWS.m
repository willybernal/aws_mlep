function mlepPushAllToAWS(instanceInfo, keyName, lFolder, rFolder, feed)
%MLEPPUSHTOAWS Summary of this function goes here
%   Detailed explanation goes here

% Get Files
allFiles = dir([lFolder filesep '*']);
files = {allFiles.name};
files = files(3:end);

% Check Matlab Pool
if isempty(gcp('nocreate'))
    parpool(instanceInfo.instCount);
end

% Create Command mkdir
[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];
cmd_mkdir = ['mkdir ' rFolder]; 
 
% Copy all files to instances
parfor i = 1:instanceInfo.instCount
    if feed
        disp('Making simulation folder on AWS');
    end
    mlepSendCommand(strtrim(instanceInfo.pubDNSName(i,:)), cmd_mkdir, keyName, feed);
    if feed
        disp('Pushing idf files to AWS');
    end
    cmd = ['scp -o StrictHostKeyChecking=no -i ' keyName ' ' lFolder filesep '* ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rFolder ' &'];
    if feed
        [status, msg] = system(cmd, '-echo');
    else
        [status, msg] = system(cmd);
    end
end

end
