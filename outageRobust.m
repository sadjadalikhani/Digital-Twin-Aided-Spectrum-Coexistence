function [F] = outageRobust(dAnt,apiAnt,apdAnt,Hii,Hli,alpha,P,percentErr)

Ai = Hii*Hii';
Al = Hli*Hli';

rho_1 = .05;
rho_2 = .05;

% rho_1 = .1;
% rho_2 = .01;

eps_1 = percentErr*norm(Hii,'fro');
eps_2 = percentErr*norm(Hli,'fro');

cvx_begin quiet

variable F(dAnt,dAnt) hermitian semidefinite

% variable x_1
% variable y_1
variable x_2
variable y_2
% variable t

expressions A_1 A_2 A_3 B_1 B_2 B_3

% A_1 = eps_1^2*apiAnt*trace(F) - sqrt(2*log(1/rho_1))*x_1 + log(rho_1)*y_1 + trace(Ai*F)-t;
% A_2 = norm([eps_1^2*sqrt(apiAnt)*vec(F);eps_1*sqrt(2)*vec(F*Hii)],2); %%% Hii'
% A_3 = y_1*eye(dAnt) + eps_1^2*F;
B_1 = -eps_2^2*apdAnt*trace(F) - sqrt(2*log(1/rho_2))*x_2 + log(rho_2)*y_2 + alpha-trace(Al*F);
B_2 = norm([eps_2^2*sqrt(apdAnt)*vec(F);eps_2*sqrt(2)*vec(F*Hli)],2);%%%
B_3 = y_2*eye(dAnt) - eps_2^2*F;

maximize real(trace(Ai*F))

subject to

%     real(A_1) >= 0;
%     real(A_2-x_1) <= 0;
%     A_3 == hermitian_semidefinite(dAnt);
%     y_1 >= 0;
    
    real(B_1) >= 0;
    real(B_2-x_2) <= 0;
    B_3 == hermitian_semidefinite(dAnt);
    y_2 >= 0;
    
    trace(F) <= P;

cvx_end





if ~isnan(F)
%% FEASIBILITY CHECK
eigF = eig(F);
flaggg = 0;
cnttt = 0;
% rankOneF = F;
flag10 = 0;
if length(eigF(abs(eigF)<1e-2 == 0)) > 1
    [eigVec,eigVal] = eig(F);
    [maxVal,idx] = max(diag(eigVal));
    rankOneF = maxVal*eigVec(:,idx)*eigVec(:,idx)';
%     A_1 = eps_1^2*apiAnt*trace(rankOneF) - sqrt(2*log(1/rho_1))*x_1 + log(rho_1)*y_1 ...
%         + trace(Ai*rankOneF)-t;
%     A_2 = norm([eps_1^2*sqrt(apiAnt)*vec(rankOneF);eps_1*sqrt(2)*vec(rankOneF*Hii)],2);
%     A_3 = y_1*eye(dAnt) + eps_1^2*rankOneF;
    B_1 = -eps_2^2*apdAnt*trace(rankOneF) - sqrt(2*log(1/rho_2))*x_2 + log(rho_2)*y_2 ...
        + alpha-trace(Al*rankOneF);
    B_2 = norm([eps_2^2*sqrt(apdAnt)*vec(rankOneF);eps_2*sqrt(2)*vec(rankOneF*Hli)],2);
    B_3 = y_2*eye(dAnt) - eps_2^2*rankOneF;
    C = trace(rankOneF) - P;
    
    if (real(B_1) >= -1e-3 ...
            && real(B_2-x_2) <= 1e-3  ...
            && min(eig(B_3)) >= -1e-3 && C <= 1e-3)
        flag10 = 1;
    end
    
    if flag10 == 0
    while flaggg == 0
        cnttt = cnttt + 1;
        if cnttt == 10 %%%
            rankOneF = zeros(dAnt,dAnt);
            break
        end
        [rankOneF] = gaussRand(F); 
%         A_1 = eps_1^2*apiAnt*trace(rankOneF) - sqrt(2*log(1/rho_1))*x_1 + log(rho_1)*y_1 ...
%             + trace(Ai*rankOneF)-t;
%         A_2 = norm([eps_1^2*sqrt(apiAnt)*vec(rankOneF);eps_1*sqrt(2)*vec(rankOneF*Hii)],2);
%         A_3 = y_1*eye(dAnt) + eps_1^2*rankOneF;
        B_1 = -eps_2^2*apdAnt*trace(rankOneF) - sqrt(2*log(1/rho_2))*x_2 + log(rho_2)*y_2 ...
            + alpha-trace(Al*rankOneF);
        B_2 = norm([eps_2^2*sqrt(apdAnt)*vec(rankOneF);eps_2*sqrt(2)*vec(rankOneF*Hli)],2);
        B_3 = y_2*eye(dAnt) - eps_2^2*rankOneF;
        C = trace(rankOneF) - P;
        
        if  (real(B_1) >= -1e-3 ...
            && real(B_2-x_2) <= 1e-3 ...
            && min(eig(B_3)) >= -1e-3 && C <= 1e-3)
            flaggg = 1;
        end
    end
    end
    F = rankOneF;
end
else
F = zeros(dAnt,dAnt);
end
    










% [t1,t2]=eig(F);
% [X,location]=max( abs(diag(t2)) );
% if length(location)==1
%     F_opt=t1(:,location)*t2(location,location)^(1/2);
% else
%     for i=1:500
%         b2(:,i)=t1*t2^(1/2)*sqrt(1/2)*(randn(dAnt,1) + sqrt(-1)*  randn(dAnt,1));
%         Obj(i)=norm(b2(:,i),2);
%     end
%     [value locat]=min(Obj);
%     F_opt=b2(:,locat);
%     rankOneF = F_opt*F_opt';
% end












% cnt3 = 0;
% 
% F3prime = zeros(dAnt,dAnt);
% F3second = 1000*ones(dAnt,dAnt);
% 
% while abs(trace(F3second-F3prime)) >= 1e-3
% 
% flag = 0;
% 
% cnt3 = cnt3 + 1;
% if cnt3 == 40
%     F3 = zeros(dAnt,dAnt);
%     break
% end
    

% end



end