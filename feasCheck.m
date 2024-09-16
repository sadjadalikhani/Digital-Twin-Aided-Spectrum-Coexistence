function [feasRateNonRobust,rateUnlicensedNonRobust, ...
    rateLicensedNonRobust,ExcessIntefpPowerdNonRobust, ...
    bfVec1,bfVec2,feasRateRobust,rateUnlicensedRobust, ...
    rateLicensedRobust,ExcessIntefpPowerdRobust,bfVec3] = feasCheck( ...
    feasLoops,Hii,Hll,Hli,Hil,percentErr,...
    alpha,F,noisePow,F2,F3,feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,csiErr,intrf,expr,mode)


CntfeasNonRobust = ones(feasLoops,1);
rateNonrobustU = zeros(feasLoops,1);
rateNonrobustL = zeros(feasLoops,1);
feasCheckNonRobust = zeros(feasLoops,1);

CntfeasRobust = ones(feasLoops,1);
rateRobustU = zeros(feasLoops,1);
rateRobustL = zeros(feasLoops,1);
feasCheckRobust = zeros(feasLoops,1);

for j = 1:feasLoops
    
    perfectHii = channelErrGen(Hii,percentErr+0,mode);
    perfectHll = channelErrGen(Hll,percentErr+0,mode);
    perfectHli = channelErrGen(Hli,percentErr+0,mode);
    perfectHil = channelErrGen(Hil,percentErr+0,mode);


    feasCheckNonRobust(j) = alpha - real(trace(perfectHli*perfectHli'*F));
    if feasCheckNonRobust(j) < -1e-3
        CntfeasNonRobust(j) = 0;
    end
    rateNonrobustU(j) = log2(1+trace(perfectHii*perfectHii'*F)/ ...
        (trace(perfectHil*perfectHil'*F2)+noisePow));
%     rateNonrobustU(j) = trace(perfectHii*perfectHii'*F);
    rateNonrobustL(j) = log2(1+trace(perfectHll*perfectHll'*F2)/ ...
        (trace(perfectHli*perfectHli'*F)+noisePow));


    feasCheckRobust(j) = alpha - real(trace(perfectHli*perfectHli'*F3));
    if feasCheckRobust(j) < -1e-3
        CntfeasRobust(j) = 0;
    end
    rateRobustU(j) = log2(1+trace(perfectHii*perfectHii'*F3)/ ...
        (trace(perfectHil*perfectHil'*F2)+noisePow));
%     rateRobustU(j) = trace(perfectHii*perfectHii'*F3);
    rateRobustL(j) = log2(1+trace(perfectHll*perfectHll'*F2)/ ...
        (trace(perfectHli*perfectHli'*F3)+noisePow));
end


feasRateNonRobust(csiErr,intrf,expr) = mean(CntfeasNonRobust);
rateUnlicensedNonRobust(csiErr,intrf,expr) = mean(rateNonrobustU);
rateLicensedNonRobust(csiErr,intrf,expr) = mean(rateNonrobustL);
feasCheckNonRobust(feasCheckNonRobust > -1e-3)=0;
ExcessIntefpPowerdNonRobust(csiErr,intrf,expr) = ...
    - mean(feasCheckNonRobust)/alpha*100;
bfVec1(csiErr,intrf,expr) = trace(F);
bfVec2(csiErr,intrf,expr) = trace(F2);


feasRateRobust(csiErr,intrf,expr) = mean(CntfeasRobust);
rateUnlicensedRobust(csiErr,intrf,expr) = mean(rateRobustU);
rateLicensedRobust(csiErr,intrf,expr) = mean(rateRobustL);
feasCheckRobust(feasCheckRobust > -1e-3)=0;
ExcessIntefpPowerdRobust(csiErr,intrf,expr) = ...
    - mean(feasCheckRobust)/alpha*100;
bfVec3(csiErr,intrf,expr) = trace(F3);


end