function mlepRemoveFolderOnAWS(instanceInfo,keyName,rFolder,feed,paraStatus)
%REMOVEFOLDERONAWS Summary of this function goes here
%   Detailed explanation goes here
% remove from aws
% Check Matlab Pool
if paraStatus
    if isempty(gcp('nocreate'))
        parpool(instanceInfo.instCount);
    end
end

% Remove File from cloud
if feed
    disp('Removing folders on AWS')
end

parfor i = 1:instanceInfo.instCount
    cmd = ['rm -r ' rFolder];
    mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd, keyName, feed);
end

end

