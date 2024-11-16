clc
% clear all
%% PARAMETERS
[H1,H2,loc,userNum,noisePow,P,dAnt,apiAnt,apdAnt, ...
    experiments,feasLoops,thr,channelErr,intrfPercent,~] = pars();

mode = 2; % CHOOSE THE ROBUST OPTIMIZATION TYPE
robust_opt_types = ["worst_case", "outage_constrained"];
robust_opt_type = robust_opt_types(mode);

% BS LOCATION PLOTS
% ap(DeepMIMO_dataset)
%% MATRICES DEFINITION
[feasRateNonRobust, ...
    feasRateRobust, ...
    rateUnlicensedNonRobust, ...
    rateLicensedNonRobust, ...
    rateUnlicensedRobust, ...
    rateLicensedRobust, ...
    ExcessIntefpPowerdNonRobust, ...
    ExcessIntefpPowerdRobust, ...
    bfVec1, ...
    bfVec2, ...
    bfVec3, ...
    iters, ...
    LicenseduserLocs, ...
    UnlicenseduserLocs] = matrices(size(channelErr,2),size(thr,2),experiments);  
%% LOOP FOR CHANNEL REALIZATIONS (BY CHOOSING DIFFERENT USERS IN THE MESH
for expr = 1:experiments    
    % PERCENT OF PROGRESS
    fprintf('-------------- ITERATION %g/%g --------------\n', ...
        expr,experiments)
    % CSI CALCULATION FOR TWO NEW USERS
    [Hii,Hli,Hil,Hll,users] = ImpCSI(H1,H2,userNum);
    % USERS' LOCATION PLOTS
%     [LicenseduserLocs,UnlicenseduserLocs] = ...
%     userDistr(users,LicenseduserLocs,UnlicenseduserLocs,expr,loc);
%% LOOP FOR INTERFERENCE ALLOWANCE PERCENTAGE
    intrf = 0;
for alpha = thr
    intrf = intrf + 1;
    
    csiErr = 0;
%% LOOP FOR CHANNEL ERROR BOUNDS    
for percentErr = channelErr
    csiErr = csiErr + 1;  

    % NON-ROBUST BEAMFORMING
    [F,F2] = nonRobust(P,Hii,dAnt,alpha,Hli,Hll);
    
    if robust_opt_type == "worst_case"
        % Worst-Case ROBUST BEAMFORMING
        F4 = zeros(dAnt,dAnt);
        [F4,iters] = robust(Hii,Hli,percentErr,dAnt,apiAnt,alpha, ...
            iters,P,csiErr,intrf,expr);
    elseif robust_opt_type == "outage_constrained"
        % Outage-Constrained ROBUST BEAMFORMING
        F4 = zeros(dAnt,dAnt);
        F4 = outageRobust(dAnt,apiAnt,apdAnt,Hii,Hli,alpha,P,percentErr);
        %F4 = robustOC_backup(dAnt,apiAnt,apdAnt,Hii,Hli,alpha,P,percentErr);
    end

    [feasRateNonRobust,rateUnlicensedNonRobust, ...
    rateLicensedNonRobust,ExcessIntefpPowerdNonRobust, ...
    bfVec1,bfVec2,feasRateRobust,rateUnlicensedRobust, ...
    rateLicensedRobust,ExcessIntefpPowerdRobust,bfVec3] = feasCheck( ...
    feasLoops,Hii,Hll,Hli,Hil,percentErr, ...
    alpha,F,noisePow,F2,F4,feasRateNonRobust, ...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,csiErr,intrf,expr,mode);
    

%     % FEASIBILITY CHECK AND RATE CLACUALTION ...
%     % ... FOR DIFFERENT BOUNDED CHANNELS WITHIN A REALIZATION 
%     [feasRateNonRobust,rateUnlicensedNonRobust, ...
%     rateLicensedNonRobust,ExcessIntefpPowerdNonRobust, ...
%     bfVec1,bfVec2,feasRateRobust,rateUnlicensedRobust, ...
%     rateLicensedRobust,ExcessIntefpPowerdRobust,bfVec3] = feasCheck( ...
%     feasLoops,Hii,Hll,Hli,Hil,percentErr, ...
%     alpha,F,noisePow,F2,F3,feasRateNonRobust, ...
%     rateUnlicensedNonRobust,rateLicensedNonRobust, ...
%     ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
%     feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
%     ExcessIntefpPowerdRobust,bfVec3,csiErr,intrf,expr);



% [a1, b1] = cart2pol(loc(users(2),1)-loc(users(2),1), ...
% loc(users(2),2)-loc(users(2),2));
% [a2, b2] = cart2pol(DeepMIMO_dataset{1}.basestation{1}.loc(1)-loc(users(2),1), ...
% DeepMIMO_dataset{1}.basestation{1}.loc(2)-loc(users(2),2));
% [a3, b3] = cart2pol(DeepMIMO_dataset{1}.basestation{2}.loc(1)-loc(users(2),1), ...
% DeepMIMO_dataset{1}.basestation{2}.loc(2)-loc(users(2),2));
% polarscatter(a1, b1,'ro','LineWidth',3,'DisplayName','UnLic UE')
% thetalim([1,360])
% hold on
% polarscatter(a2, b2,'b+','LineWidth',3,'DisplayName','Lic BS')
% thetalim([1,180])
% hold on
% polarscatter(a3, b3,'r+','LineWidth',3,'DisplayName','UnLic BS')
% thetalim([1,360])
% hold on
% deg = 360;
% patt = zeros(deg,1);
% for theta = 1:deg
% patt(theta) = beamPatt(4,theta,.5,F);
% end
% polarplot(deg2rad(1:deg), patt)
% hold on
% figure(2)
% polarscatter(a1, b1,'ro','LineWidth',3,'DisplayName','UnLic UE')
% thetalim([1,360])
% hold on
% polarscatter(a2, b2,'b+','LineWidth',3,'DisplayName','Lic BS')
% thetalim([1,180])
% hold on
% polarscatter(a3, b3,'r+','LineWidth',3,'DisplayName','UnLic BS')
% thetalim([1,360])
% hold on
% patt = zeros(deg,1);
% for theta = 1:deg
% patt(theta) = beamPatt(4,theta,.5,F4);
% end
% polarplot(deg2rad(1:deg), patt)
% hold on
end
end
% SHOWS REAL-TIME RESULTS  
nonRobustRate = real(mean(rateUnlicensedNonRobust(:,:,1:expr),3))
robustRate = real(mean(rateUnlicensedRobust(:,:,1:expr),3))
% nonRobustRateL = real(mean(rateLicensedNonRobust(:,:,1:expr),3))
% robustRateL = real(mean(rateLicensedRobust(:,:,1:expr),3))
% powerNonRobust = 10*log10(real(mean(bfVec1(:,:,1:expr),3))*1000)
% powerRobust = 10*log10(real(mean(bfVec3(:,:,1:expr),3))*1000)
% IntrfNonRobust = real(mean(ExcessIntefpPowerdNonRobust(:,:,1:expr),3))
% IntrfRobust = real(mean(ExcessIntefpPowerdRobust(:,:,1:expr),3))
feasNonRobust = real(mean(feasRateNonRobust(:,:,1:expr),3))*100
feasRobust = real(mean(feasRateRobust(:,:,1:expr),3))*100
end
%% SAVE RESULTS
saveMat(feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,iters)
% %% FIGURES
% plotFigs(feasRateNonRobust,...
%     rateUnlicensedNonRobust,rateLicensedNonRobust, ...
%     ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
%     feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
%     ExcessIntefpPowerdRobust,bfVec3,iters,channelErr,intrfPercent)