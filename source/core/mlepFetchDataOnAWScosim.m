function mlepFetchDataOnAWScosim(instanceInfo,keyName,rFolder,feed)
%MLEPFETCHDATAONAWS This function fetches all the .csv files from the cloud
% instances
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal
if isempty(gcp('nocreate'))
    parpool(instanceInfo.instCount);
end

if exist('Output', 'dir')
    rmdir('Output', 's');
end
mkdir('Output');

% Check Folder Name
[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];

lfile = 'Output/.';
rfile = [rFolder filesep 'out/*'];

parfor i = 1:instanceInfo.instCount
    cmd = ['scp -r -i '  keyName ' ubuntu@' strtrim(instanceInfo.pubDNSName(i,:)) ':' rfile ' ' lfile ];
    if feed
        [stastus, msg] = system(cmd, '-echo');
    else
        [stastus, msg] = system(cmd);
    end        
end

end

