function [Hii,Hli,Hil,Hll,users] = ImpCSI(H1,H2,userNum)

% CHOOSE TWO USERS AS LICENSED AND UNLICENSED USERS IN EACH EXPERIMENT
users = rndRows([1,userNum],2);
% COMPUTE CHANNELS AND CROSS-CHANNELS
Hii = H2(:,:,users(2)); %bs2(u) - ue2(u)
Hli = H1(:,:,users(2)); %bs1(l) - ue2(u)
Hil = H2(:,:,users(1));
Hll = H1(:,:,users(1));

end