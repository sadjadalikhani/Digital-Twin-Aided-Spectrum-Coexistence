function [feasRateNonRobust,rateUnlicensedNonRobust, ...
    rateLicensedNonRobust,ExcessIntefpPowerdNonRobust, ...
    bfVec1,bfVec2,feasRateRobust,rateUnlicensedRobust, ...
    rateLicensedRobust,ExcessIntefpPowerdRobust,bfVec3] = feasCheckLocs( ...
    Hll,Hil,...
    alpha,F,noisePow,F2,F3,feasRateNonRobust,...
    rateUnlicensedNonRobust,rateLicensedNonRobust, ...
    ExcessIntefpPowerdNonRobust,bfVec1,bfVec2,...
    feasRateRobust,rateUnlicensedRobust,rateLicensedRobust, ...
    ExcessIntefpPowerdRobust,bfVec3,csiErr,rad,expr,H1,H2, ...
    users,loc,radius)

idx = findNearest(loc,loc(users(2),:),radius+1e-4);
% idx = findNearest(loc,loc(users(2),:),radius+1e-1);
% idx = idx(randperm(length(idx),1));

CntfeasNonRobust = ones(length(idx),1);
rateNonrobustU = zeros(length(idx),1);
rateNonrobustL = zeros(length(idx),1);
feasCheckNonRobust = zeros(length(idx),1);

CntfeasRobust = ones(length(idx),1);
rateRobustU = zeros(length(idx),1);
rateRobustL = zeros(length(idx),1);
feasCheckRobust = zeros(length(idx),1);

j = 0;
for k = 1:length(idx)
    i = idx(k);
    
    j = j + 1; 

    perfectHii = H2(:,:,i);
    perfectHli = H1(:,:,i);


    feasCheckNonRobust(j) = alpha - real(trace(perfectHli*perfectHli'*F));
    if feasCheckNonRobust(j) < -1e-3
        CntfeasNonRobust(j) = 0;
    end
    rateNonrobustU(j) = log2(1+trace(perfectHii*perfectHii'*F)/ ...
        (trace(Hil*Hil'*F2)+noisePow));
%     rateNonrobustU(j) = trace(perfectHii*perfectHii'*F);
    
    rateNonrobustL(j) = log2(1+trace(Hll*Hll'*F2)/ ...
        (trace(perfectHli*perfectHli'*F)+noisePow));


    feasCheckRobust(j) = alpha - real(trace(perfectHli*perfectHli'*F3));
    if feasCheckRobust(j) < -1e-3
        CntfeasRobust(j) = 0;
    end
    rateRobustU(j) = log2(1+trace(perfectHii*perfectHii'*F3)/ ...
        (trace(Hil*Hil'*F2)+noisePow));
%     rateRobustU(j) = trace(perfectHii*perfectHii'*F3);
    
    rateRobustL(j) = log2(1+trace(Hll*Hll'*F2)/ ...
        (trace(perfectHli*perfectHli'*F3)+noisePow));
end

feasRateNonRobust(csiErr,rad,expr) = mean(CntfeasNonRobust);
rateUnlicensedNonRobust(csiErr,rad,expr) = mean(rateNonrobustU);
rateLicensedNonRobust(csiErr,rad,expr) = mean(rateNonrobustL);
feasCheckNonRobust(feasCheckNonRobust > -1e-3)=0;
ExcessIntefpPowerdNonRobust(csiErr,rad,expr) = ...
    - mean(feasCheckNonRobust)/alpha*100;
bfVec1(csiErr,rad,expr) = trace(F);
bfVec2(csiErr,rad,expr) = trace(F2);


feasRateRobust(csiErr,rad,expr) = mean(CntfeasRobust);
rateUnlicensedRobust(csiErr,rad,expr) = mean(rateRobustU);
rateLicensedRobust(csiErr,rad,expr) = mean(rateRobustL);
feasCheckRobust(feasCheckRobust > -1e-3)=0;
ExcessIntefpPowerdRobust(csiErr,rad,expr) = ...
    - mean(feasCheckRobust)/alpha*100;
bfVec3(csiErr,rad,expr) = trace(F3);

end