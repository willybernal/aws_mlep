function mlepRunSimulationCosim(instanceInfo, keyName, lFolder, rFolder, feed)
%MLEPRUNSIMULATIONONCOSIM Runs Simulation of E+ 
%   This functions launches all the E+ simulations in the specified folder
%   (rFolder)
%   Inputs: 
%       instanceInfo - cell with all the instances information
%       keyName - Path to the key file 
%       rFolder - Folder in the EC2 instances where the E+ files reside.
% 
% This script is free software.
%
% (C) 2015 by Willy Bernal(willyg@seas.upenn.edu)

% start matlabpool for parallel execution
if isempty(gcp('nocreate'))
    parpool(instanceInfo.instCount);
end

[a, b, c] = fileparts(rFolder);
rFolder = [a filesep b];

% for each EC2 instance
parfor i = 1:instanceInfo.instCount
    allFiles= dir([lFolder num2str(i) filesep '*.txt']);
    files = {allFiles.name};
    fileNo = size(files,2);
    for j = 1:fileNo
        % Rename input.txt (#.txt)
        cmd = ['mv '  rFolder filesep char(files(j)) ' ' rFolder filesep 'input.txt'];
        mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd, keyName, feed);
        % Run Simulation
        cmd = ['cd ' rFolder ';./super'];
        mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd, keyName, feed);
        % Rename Output
        [~,filename,~] = fileparts(files{j}); 
        cmd = ['mv ' rFolder filesep 'super.mat ' rFolder filesep char(filename) '.mat'];
        mlepSendCommand(instanceInfo.pubDNSName(i,:), cmd, keyName, feed);
        if feed
            msg = ['Simulation ',num2str(j), ' on machine #',num2str(i), ' done' ];
            disp(msg);
        end
    end 
end