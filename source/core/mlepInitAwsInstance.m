function ec2Inst = mlepInitAwsInstance(amazonEC2Client, numInst, keyPath, securityGroup, instType, amiCode)
%MLEPINITAWSINSTANCE A function for creating EC2 instance. 
%   Inputs:
%       amazonEC2Client - 
%       numInst - Number of Instances to dispatch
%       keyPath - Path to aws key
%       securityGroup - Security group in aws
%       instType - Type of instance (e.g. 't1.micro')
%       amiCode - Code of the instance ('ami-33aef35a')
%
% This script is free software.
%
% (C) 2013 by Willy Bernal(willybernal@gmail.com)

% CHANGES:
%   2013-09-11  Created. 
%   2015-06-17  Updated Help.
disp('===========================================');
disp('Run Instances!');
disp('===========================================');

% Prepare Inputs
imageID = java.lang.String(amiCode);
instanceType = java.lang.String(instType);
[~,keyName,~] = fileparts(keyPath);

% Create Request
runInstancesRequest = com.amazonaws.services.ec2.model.RunInstancesRequest();
runInstancesRequest.withImageId(imageID)...
    .withInstanceType(instanceType)...
    .withKeyName(keyName)...
    .withMinCount(java.lang.Integer(numInst))...
    .withMaxCount(java.lang.Integer(numInst)).withSecurityGroups(securityGroup);

% Launch Instance
runInstancesResult = amazonEC2Client.runInstances(runInstancesRequest);
reservationsLaunched = runInstancesResult.getReservation();
reservationLaunchedID = reservationsLaunched.getReservationId();
instancesLaunched = reservationsLaunched.getInstances();

% Describe Instances
describeInstanceResult = amazonEC2Client.describeInstances();
reservations = describeInstanceResult.getReservations();
resNum = 0;
while ~strcmp(char(reservations.get(resNum).getReservationId), char(reservationLaunchedID))
    resNum = resNum + 1;
end
reservation = reservations.get(resNum);
instances = reservation.getInstances;
for i=1:instances.size
    instance = instances.get(i-1);
    % Check if instance running
    while ~strcmp(char(instance.getState.getName),'running')
        describeInstanceResult = amazonEC2Client.describeInstances();
        reservations = describeInstanceResult.getReservations();
        resNum = 0;
        while ~strcmp(char(reservations.get(resNum).getReservationId), char(reservationLaunchedID))
            resNum = resNum + 1;
        end
        reservation = reservations.get(resNum);
        instances = reservation.getInstances;
        instance = instances.get(i-1);
    end
    % Display which instances running
    disp(['Intance with ID ' char(instance.getInstanceId()) ' is ' char(instance.getState.getName)]);
    
    % Create struct with instances
    ec2Inst.instCount = instances.size;
    ec2Inst.instanceId{i} = instance.getInstanceId();
    ec2Inst.pubDNSName{i} = instance.getPublicDnsName();
end
% Prepare Instance
ec2Inst = struct();
disp('===========================================');
disp('Done!');
disp('===========================================');
