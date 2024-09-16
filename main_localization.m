clc
% clear all
%% PARAMETERS
[H1,H2,loc,userNum,noisePow,P,dAnt,apiAnt,apdAnt, ...
    experiments,feasLoops,thr,channelErr,alpha,r] = pars();
intrf = 1;
%% MATRICES DEFINITION
[feasRateNonRobust,...
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
    UnlicenseduserLocs] = ...
    matrices(size(channelErr,2),size(r,2),experiments);  
%% LOOP FOR CHANNEL REALIZATIONS
for expr = 1:experiments    
    % PERCENT OF PROGRESS
    fprintf('-------------- ITERATION %g/%g --------------\n', ...
        expr,experiments)
    % CSI CALCULATION FOR TWO NEW USERS
    [Hii,Hli,Hil,Hll,users] = ImpCSI(H1,H2,userNum); 
    % NON-ROBUST BEAMFORMING
    [F,F2] = nonRobust(P,Hii,dAnt,thr,Hli,Hll);
%% LOOP FOR INTERFERENCE ALLOWANCE PERCENTAGE
    csiErr = 0;
%% LOOP FOR CHANNEL ERROR BOUNDS    
for percentErr = channelErr
    csiErr = csiErr + 1;  
    % Worst-Case ROBUST BEAMFORMING
    F4 = zeros(dAnt,dAnt);
    [F4,iters] = robust(Hii,Hli,percentErr,dAnt,apiAnt,alpha, ...
        iters,P,csiErr,intrf,expr);
%     % OUTAGE-CONSTRAINED
%     F4 = zeros(dAnt,dAnt);
%     F4 = outageRobust(dAnt,apiAnt,apdAnt,Hii,Hli,thr,P,percentErr);
    for e = 1:1
    %% BEAM PATTERN PLOT
%     b1 = 0;
%     b2 = 0;
%     for e = 1:1000
%     perfectHli = channelErrGen(Hli,percentErr,2);
%     b1 = b1 + (sign(alpha - real(trace(perfectHli*perfectHli'*F)))+1)/2;
%     b2 = b2 + (sign(alpha - real(trace(perfectHli*perfectHli'*F4)))+1)/2;
%     end
%     b1 = b1/1000;
%     b2 = b2/1000;
%     
%     a = zeros(3,2);
%     
%     figure(32563)
%     a(1,:) = cart2pol(loc(users(2),1)-loc(users(2),1), ...
%         loc(users(2),2)-loc(users(2),2));
%     a(2,:) = cart2pol(DeepMIMO_dataset{1}.basestation{1}.loc(1)-loc(users(2),1), ...
%         DeepMIMO_dataset{1}.basestation{1}.loc(2)-loc(users(2),2));
%     a(3,:) = cart2pol(DeepMIMO_dataset{1}.basestation{2}.loc(1)-loc(users(2),1), ...
%         DeepMIMO_dataset{1}.basestation{2}.loc(2)-loc(users(2),2));
%     clf
%     polarscatter(a(1,1), a(1,2),'ro','LineWidth',3,'DisplayName','UnLic UE')
%     thetalim([1,180])
%     hold on
%     polarscatter(a(2,1), a(2,2),'b+','LineWidth',3,'DisplayName','Lic BS')
%     thetalim([1,180])
%     hold on
%     polarscatter(a(3,1), a(3,2),'r+','LineWidth',3,'DisplayName','UnLic BS')
%     thetalim([1,180])
%     hold on 
%     
%     deg = 180;
%     patt = zeros(deg,1);
%     for theta = 1:deg
%         patt(theta) = beamPatt(4,theta,.5,F);
%     end
%     polarplot(deg2rad(1:deg), patt, 'k--','DisplayName',sprintf("%g",b1))
%     hold on
%     
%     patt = zeros(deg,1);
%     for theta = 1:deg
%         patt(theta) = beamPatt(4,theta,.5,F4);
%     end
%     polarplot(deg2rad(1:deg), patt, 'k','DisplayName',sprintf("%g",b2))
%     legend()
%     drawnow;
    %%
    end
    rad = 0;
for radius = r
    rad = rad + 1;
    [feasRateNonRobust,rateUnlicensedNonRobust, ...
    rateLicensedNonRobust,ExcessIntefpPowerdNonRobust, ...
    bfVec1,bfVec2,feasRateRobust,rateUnlicensedRobust, ...
    rateLicensedRobust,ExcessIntefpPowerdRobust,bfVec3] = feasCheckLocs( ...
    Hll,Hil,...
    thr,F,noisePow,F2,F4,feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,csiErr,rad,expr,H1,H2, ...
    users,loc,radius);
end
end
% SHOWS REAL-TIME RESULTS  
nonRobustRate = real(mean(rateUnlicensedNonRobust(:,:,1:expr),3));
nonRobustRate(1,:)
robustRate = real(mean(rateUnlicensedRobust(:,:,1:expr),3))
nonRobustRateL = real(mean(rateLicensedNonRobust(:,:,1:expr),3));
robustRateL = real(mean(rateLicensedRobust(:,:,1:expr),3));
powerNonRobust = 10*log10(real(mean(bfVec1(:,:,1:expr),3))*1000);
powerNonRobust(1,:);
powerRobust = 10*log10(real(mean(bfVec3(:,:,1:expr),3))*1000);
powerRobust;
IntrfNonRobust = real(mean(ExcessIntefpPowerdNonRobust(:,:,1:expr),3));
IntrfNonRobust(1,:)
IntrfRobust = real(mean(ExcessIntefpPowerdRobust(:,:,1:expr),3))
feasNonRobust = real(mean(feasRateNonRobust(:,:,1:expr),3))*100;
feasNonRobust(1,:)
feasRobust = real(mean(feasRateRobust(:,:,1:expr),3))*100
end
%% SAVE RESULTS
saveMat(feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,iters)
%% FIGURES
% plotFigs(feasRateNonRobust,...
%     rateUnlicensedNonRobust,rateLicensedNonRobust, ...
%     ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
%     feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
%     ExcessIntefpPowerdRobust,bfVec3,iters,channelErr,intrfPercent)

plotFigs2(feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,iters,channelErr,r)