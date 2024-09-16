function [LicenseduserLocs,UnlicenseduserLocs] = ...
    userDistr(users,LicenseduserLocs,UnlicenseduserLocs,expr,loc)

%% SAVE USERS' LOCATIONS 
LicenseduserLocs(expr) = loc(users(2));
UnlicenseduserLocs(expr) = loc(users(1));
%% USERS' DISTRIBUTION ON THE SCENARIO O1 OF THE DEEPMIMO DATASET
figure(23)
scatter(loc(users(2),1),loc(users(2),2),'b','DisplayName','Licensed Users')
hold on
scatter(loc(users(1),1),loc(users(1),2),'r','DisplayName','Unicensed Users')
hold on 
grid minor
end