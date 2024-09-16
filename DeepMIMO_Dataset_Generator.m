clc
% clear all

% ----------------- Add the path of DeepMIMO function --------------------%
addpath('DeepMIMO_functions')

% -------------------- DeepMIMO Dataset Generation -----------------------%
format shortG
% r = [700:1500, 3000:3852];
r = [3000:3600];
num = length(r)*181;
dSize = 1;
APSize = 1;
H1 = zeros(dSize,APSize,num);
H2 = zeros(dSize,APSize,num);
loc = zeros(num,2);

cnt3 = 0; 
cnt = -1;
for i = r
    cnt = cnt + 1;
    (cnt+1)/length(r)*100

    dataset_params = read_params('parameters.m');
    
    dataset_params.active_user_first = i;
    dataset_params.active_user_last = i;
    
    [DeepMIMO_dataset, dataset_params] = DeepMIMO_generator(dataset_params);

    userNum = size(DeepMIMO_dataset{1}.user);
    userNum = userNum(2);
    selecetedUEs = 1:userNum;
    eachRow = userNum;

    for j = selecetedUEs
        
        cnt3 = cnt3 + 1;
        
        H1(:,:,cnt3) = DeepMIMO_dataset{1}.user{j}.channel;
        H2(:,:,cnt3) = DeepMIMO_dataset{2}.user{j}.channel;
        pos = DeepMIMO_dataset{1}.user{j}.loc;
        loc(cnt3,:) = pos(1:2);
  
    end
end
%%
% formatDescr = 'ddmmmyyyyHHMMSS';
% datestring = datestr(now, formatDescr);
% save(strcat('H1_',datestring,'.mat'),'H1');
% save(strcat('H2_',datestring,'.mat'),'H2');
% save(strcat('loc_',datestring,'.mat'),'loc');
%%


% -------------------------- Output Examples -----------------------------%
% DeepMIMO_dataset{i}.user{j}.channel % Channel between BS i - User j
% %  (# of User antennas) x (# of BS antennas) x (# of OFDM subcarriers)
%
% DeepMIMO_dataset{i}.user{j}.params % Parameters of the channel (paths)
% DeepMIMO_dataset{i}.user{j}.LoS_status % Indicator of LoS path existence
% %     | 1: LoS exists | 0: NLoS only | -1: No paths (Blockage)|
%
% DeepMIMO_dataset{i}.user{j}.loc % Location of User j
% DeepMIMO_dataset{i}.loc % Location of BS i
%
% % BS-BS channels are generated only if (params.enable_BSchannels == 1):
% DeepMIMO_dataset{i}.basestation{j}.channel % Channel between BS i - BS j
% DeepMIMO_dataset{i}.basestation{j}.loc
% DeepMIMO_dataset{i}.basestation{j}.LoS_status
%
% % Recall that the size of the channel vector was given by 
% % (# of User antennas) x (# of BS antennas) x (# of OFDM subcarriers)
% % Each of the first two channel matrix dimensions follows a certain 
% % reshaping sequence that can be obtained by the following
% % 'antennamap' vector: Each entry is 3 integers in the form of 
% % 'xyz' where each representing the antenna number in x, y, z directions
% antennamap = antenna_channel_map(params.num_ant_BS(1), ...
%                                  params.num_ant_BS(2), ...
%                                  params.num_ant_BS(3), 1);
%
% -------------------------- Dynamic Scenario ----------------------------%
%
% DeepMIMO_dataset{f}{i}.user{j}.channel % Scene f - BS i - User j
% % Every other command applies as before with the addition of scene ID
% params{f} % Parameters of Scene f
%
% ------------------------------------------------------------------------%