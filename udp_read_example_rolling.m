
%%

clear all
clc
close all

u4008 = scannerInit(4008);
scannerZERO(u4008)

f = 33; %approx sample rate
T = 3; % width of plot in seconds
N = T*f; % estimated number of samples in first window
px_ = zeros(N,16)*NaN; % empty buffer
t = linspace(0,T,N); % approx time vector to fill with real timestamps

i = 1;

while true
    
    u4008.flush
    
    if i == 1
        t0 = cputime;
    end
    
    if i > N
        px_ = circshift(px_,-1);
        px_(N,:) = scannerRead(u4008);
        
        t = circshift(t,-1);
        t(N) = cputime - t0;
        
        
    else
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



clear u4008

function u = scannerInit(port)

u = udpport("datagram",'LocalPort',port);
u.flush

end

function scannerZERO(u)

data = read(u,1,'string');
write(u,'ZERO','string',data.SenderAddress,data.SenderPort)

end

function px = scannerRead(u)

data = read(u,1,'string');
px_tmp = split(data.Data,',');
px = zeros(1,16);

for i = 1:16
    px(i) = str2double(px_tmp(i));
end



end



