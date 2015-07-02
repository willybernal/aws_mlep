function [indMap] = mlepPushToAWS(instanceInfo, keyName, lFolder, rFolder, feed,paraStatus)
%MLEPPUSHTOAWS Summary of this function goes here
%   Detailed explanation goes here

% Get Files
allFiles = dir([lFolder filesep '*']);
files = {allFiles.name};
files = files(3:end);

% Create Vector of Files with their corresponding Instances
indMap = repmat([1:instanceInfo.instCount], 1, 100);
indMap = indMap(1:size(files,2));
indMap = sort(indMap);

% Check Matlab Pool
if paraStatus
    if isempty(gcp('nocreate'))
        parpool(instanceInfo.instCount);
    end
end

[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];
cmd_mkdir = ['mkdir ' rFolder]; 
% [a, b, c] = fileparts(lFolder);
% lFolder = [b filesep '*']

parfor i = 1:instanceInfo.instCount
    if feed
        disp('Removing Local Folders');
    end
    cmd = ['rm -r ' lFolder num2str(i)]; 
    if feed
        [status, msg] = system(cmd, '-echo');
    else
        [status, msg] = system(cmd);
    end
end
 
% Copy respective files to Local Folders
parfor i = 1:instanceInfo.instCount
    if feed
        disp('Making Local Folders');
    end
    cmd = ['mkdir ' lFolder num2str(i)]; 
    if feed 
        [status, msg] = system(cmd, '-echo');
    else
        [status, msg] = system(cmd);
    end
    if feed
        disp('Copying files');
    end
    instFile = files(indMap==i);
    for j = instFile
        cmd = ['cp ' lFolder filesep char(j) ' ' lFolder num2str(i)]; 
        [status, msg] = system(cmd);
    end
end

% Copy respective files to instances
parfor i = 1:instanceInfo.instCount
    if feed
        disp('Making simulation folder on AWS');
    end
    mlepSendCommand(strtrim(instanceInfo.pubDNSName(i,:)), cmd_mkdir, keyName, feed);
    if feed
        disp('Pushing files to AWS');
    end
    cmd = ['scp -o StrictHostKeyChecking=no -i ' keyName ' ' lFolder num2str(i) filesep '* ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rFolder ' &'];
    if feed
        [stastus, msg] = system(cmd, '-echo');
    else
        [stastus, msg] = system(cmd);
    end
end

end
