function [H1,H2,loc,userNum,noisePow,P,dAnt,apiAnt,apdAnt, ...
    experiments,feasLoops,thr,channelErr,intrfPercent,radius] = pars()

%% SINGLE-ANTENNA
% features = load('features_21Feb2024105937.mat').features;
% H1 = load('H1_23Feb2024140921.mat').H1;
% H2 = load('H2_23Feb2024140921.mat').H2;
% loc = load('loc_23Feb2024140921.mat').loc;
%% MULTI-ANTENNA (FOUR EACH OF USERS AND BSs)
% H1 = load('H1_08Mar2024170911.mat').H1;
% H2 = load('H2_08Mar2024170911.mat').H2;
% loc = load('loc_08Mar2024170911.mat').loc;
% %% two
% H1 = load('H1_09Mar2024132603.mat').H1;
% H2 = load('H2_09Mar2024132603.mat').H2;
% loc = load('loc_09Mar2024132603.mat').loc;
%% two
% H1 = load('H1_14Mar2024141241.mat').H1;
% H2 = load('H2_14Mar2024141241.mat').H2;
% loc = load('loc_14Mar2024141241.mat').loc;
%% 4*8
H1 = load('H1_19Mar2024182632.mat').H1;
H2 = load('H2_19Mar2024182632.mat').H2;
loc = load('loc_19Mar2024182632.mat').loc;
%%
% H1 = H1*1e5;
% H2 = H2*1e5;

H1 = H1/3.1623e-06 + 1e-4*(randn + 1i*randn);
H2 = H2/3.1623e-06 + 1e-4*(randn + 1i*randn);
% H1 = H1/3.1623e-06;
% H2 = H2/3.1623e-06;

userNum = size(H1,3);

% dAnt = 1;
% apiAnt = 1;
% apdAnt = 1;
dAnt = 4;
apiAnt = 8;
apdAnt = 8;

% noisePow = 2e1;
noisePow = dAnt/2;
% noisePow = 10*log10(0.05*1e6)+6-100;
% noisePow = (10^((noisePow-30)/10))/3.1623e-6;
P = dAnt;

experiments = 20e2;
% experiments = 1000;
feasLoops = 1e3;

% intrfPercent = [.1,.2,.3,.4,.5,.6,.7,.8,.9]; % WORST-CASE
intrfPercent = [.5]; 
thr = noisePow.*(1-intrfPercent)./intrfPercent;

% channelErr = [.01,.02,.03,.05,.07,.09,.11]; % OUTAGE
% channelErr = [.001,.01,.025,.05,.075,.1]; % OUTAGE
% channelErr = [.001,.01,.025,.05,.075,.1]; % WORST-CASE


% channelErr = [.001,.01,.1,1,5]; % WORST-CASE

% channelErr = [1]; % WORST-CASE
% channelErr = [.01,.05,.1]; % OUTAGE

channelErr = [1]; % OUTAGE
% radius = .2*[1,5];
radius = .2*[1,2,5,10];
% radius = .2*[1];




% channelErr = [.01,.1];
% channelErr = [.4];
% channelErr = [.01,.2]; %% OUTAGE