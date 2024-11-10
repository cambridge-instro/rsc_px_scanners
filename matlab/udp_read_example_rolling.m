
%
% Simple example to read a CI pressure scanner and plot the data on a
% rolling timebase
%
% Cambridge Instrumentation, '23
%

clear all
clc
close all

% Initialise the scanner using the port set in the web interface in setup
% mode
u4008 = scannerInit(4008);

% Comment out the following "ZERO" command if not needed, WARNING, must be wind off to zero
scannerZERO(u4008)

f   = 33;                 % approx sample rate
T   = 3;                  % width of plot in seconds
N   = T * f;              % estimated number of samples in first window
px_ = zeros(N,16) * NaN;  % empty buffer
t   = linspace(0,T,N);    % approx time vector to fill with real timestamps

i = 1;

while true
    
    % flush the udp buffer to get latest data
    u4008.flush
    
    % start the timebase
    if i == 1
        t0 = cputime;
    end
    
    if i > N
        
        px_ = circshift(px_,-1);
        
        % get the pressure data
        px_(N,:) = scannerRead(u4008);
        
        t = circshift(t,-1);
        t(N) = cputime - t0;
        
    else
        
        % get the pressure data
        px_(i,:) = scannerRead(u4008);
        t(i) = cputime - t0;
        
    end
    
    
    if mod(i,3) == 0
        
        h2 = plot(t,px_);
        
        if i > N
            xlim([t(N)-T, t(N)]);
        else
            xlim([0, T]);
        end
        
    end
    
    i = i+1;
    
end

%
% helper functions to keep things tidy
%

function u = scannerInit(port)

    %
    % this is now compatible with Matlab 2024a onwards
    %

    % start a udp object at the port setup with the webtool, or hard-coded into the scanner
    u = udpport("datagram",'LocalPort',port);
    u.flush

end

function scannerZERO(u)

    % grab the listening port and IP address ready to send the "ZERO"
    % command
    data = read(u,1,'string');
    
    
    % write a "ZERO" command, !!! WARNING !!! make sure the wind is off
    write(u,'ZERO','string',data.SenderAddress,data.SenderPort)

end

function px = scannerRead(u)

    % read the data from the udp object 
    data = read(u,1,'string');
    
    px_tmp = split(data.Data,',');
    
    px = zeros(1,16);

    for i = 1:16
        
        % convert from strings to double
        px(i) = str2double(px_tmp(i));
    
    end


end



