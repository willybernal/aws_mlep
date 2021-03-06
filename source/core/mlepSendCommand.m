function mlepSendCommand(publicDnsName, cmd, keyName, feed)
%SENDCOMMANDFEED A function for sending commands to the EC2 instance
%   Inputs:
%       publicDnsName - EC2 Instance public DNS Name
%       cmd - String with command
%       keyName - Key to access your EC2 instance
%       feed - boolean true for displaying output stream
%
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Last update: 2013-09-11 by Willy Bernal

% JSch
try
jsch = com.jcraft.jsch.JSch();
jsch.addIdentity(keyName);
jsch.setConfig('StrictHostKeyChecking', 'no');

% enter your own EC2 instance IP here
publicDnsName = strtrim(publicDnsName);
session=jsch.getSession('ubuntu', publicDnsName, 22);
session.connect();
    
% run stuff
command = cmd;
channel = session.openChannel('exec');
channel.setCommand(command);
% channel.setInputStream();
channel.setErrStream(java.lang.System.err);
channel.connect();
input = channel.getInputStream();

if feed
    % start reading the input from the executed commands on the shell
    str = ones(1,1024);
    while (true)
        while (input.available() > 0)
            i = 1;
            cnt = 0;
            while (i > 0)
                i = input.read();
                cnt = cnt+1;
                str(cnt) = i;
                if (i < 0)
                    break;
                end
            end
            disp(char(str(1:cnt-1)));
        end
        
        if (channel.isClosed())
            if (input.available()>0) 
                continue;
            end
            disp(java.lang.String(['(SndCmd) exit-status: ' num2str(channel.getExitStatus())]));
            break;
        end
        
    end
end
channel.disconnect();
session.disconnect();
% disp(session.getClientVersion)
    
catch ErrObj
% 	rethrow(ErrObj);
    disp(session.getClientVersion)
%     disp(ErrObj);
    disp(ErrObj.ExceptionObject);
end