function [] = plotFigs(feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,iters,channelErr,intrfPercent)

r = 0;
for j = 1:length(intrfPercent)
    %% AVERAGE RATES OVER THE EXPERIMENTS    
a = real(mean(rateUnlicensedNonRobust,3));
a = a(:,j);
b = real(mean(rateLicensedNonRobust,3));
b = b(:,j);
b2 = real(mean(rateLicensedRobust,3));
b2 = b2(:,j);
c = real(mean(rateUnlicensedRobust,3));
c = c(:,j);
d = real(mean(feasRateNonRobust,3))*100;
d = d(:,j);
e = real(mean(feasRateRobust,3))*100;
e = e(:,j);
pow = real(mean(bfVec3,3));
pow = pow(:,j);
pow2 = real(mean(bfVec1,3));
pow2 = pow2(:,j);
iterations = real(nanmean(iters,3));
iterations = iterations(:,j);
excessNon = real(mean(ExcessIntefpPowerdNonRobust,3));
excessNon = excessNon(:,j);
excessRob = real(mean(ExcessIntefpPowerdRobust,3));
excessRob = excessRob(:,j);
    %% TRANSMISSION POWERS

    %% FIGURE OF THE RATE AT AP_i 
figure(1)
plot(channelErr,a,'-o','DisplayName', ...
    sprintf("r = %0.5g",r(j)),'Linewidth',1.2)
hold on
plot(channelErr,c,'-o','DisplayName',...
    sprintf("r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Effective Spectral Efficiency at the Unlicensed BS (bits/s/Hz)")
legend('Location', 'Best')
grid on
hold on
    %% FIGURE OF THE RATE AT AP_l 
figure(2)
plot(channelErr,b,'-o','DisplayName',...
    sprintf("Non-robust, r = %0.5g",r(j)),'Linewidth',1.2)
hold on
plot(channelErr,b2,'-o','DisplayName',...
    sprintf("Robust, r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Effective Spectral Efficiency at the Licensed BS (bits/s/Hz)")
legend('Location', 'Best')
grid on
hold on
%%
    %% FIGURE OF THE RATE AT AP_i 
figure(3)
plot(channelErr,d,'-o','DisplayName',...
    sprintf("Non-Robust: r = %0.5g",r(j)),'Linewidth',1.2)
hold on
plot(channelErr,e,'--+','DisplayName',...
    sprintf("Robust: r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Feasibility Rate of the Non-Robust Beamforming Algorithm (%)")
legend('Location', 'Best')
grid on
hold on
    %%
figure(4)
plot(channelErr,10*log10(pow*1000),'--+','DisplayName',...
    sprintf("Robust: r = %0.5g",r(j)),'Linewidth',1.2)
hold on
plot(channelErr,10*log10(pow2*1000),'--+','DisplayName',...
    sprintf("Non-robust: r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Tranmit Power at the Unlicensed User (dBm)")
legend('Location', 'Best')
grid on
hold on
    %%
figure(5)
plot(channelErr,iterations,'--+','DisplayName',...
    sprintf("Robust: r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Iterations")
legend('Location', 'Best')
grid on
hold on
    %%
figure(6)
plot(channelErr,excessNon,'--+','DisplayName',...
sprintf("Non-robust, r = %0.5g",r(j)),'Linewidth',1.2)
hold on
plot(channelErr,excessRob,'--+','DisplayName',...
sprintf("Robust, r = %0.5g",r(j)),'Linewidth',1.2)
plotbrowser
xlabel("Interference Allowed at the Licensed BS (%)")
ylabel("Excess Interference Power at the Licensed BS")
legend('Location', 'Best')
grid on
hold on
end


end