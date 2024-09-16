function [F3,iters] = robust(Hii,Hli,percentErr,dAnt,apiAnt, ...
    alpha,iters,P,csiErr,intrf,expr)

Ai = Hii*Hii';
Al = Hli*Hli';

xi_1 = percentErr*norm(Hii,'fro');
xi_2 = percentErr*norm(Hli,'fro');

mu = 10*xi_1^2 + 1e-3;
% mu = 1;

cnt3 = 0;

F3prime = zeros(dAnt,dAnt);
F3second = 1000*ones(dAnt,dAnt);

while abs(trace(F3second-F3prime)) >= 1e-3

flag = 0;

cnt3 = cnt3 + 1;
if cnt3 == 40
    F3 = zeros(dAnt,dAnt);
    break
end

%% FIRST OPTMIZATION
F3prime = F3second;
if ~isnan(mu)
if alpha ~= 0
cvx_begin quiet
    variable F3(dAnt,dAnt) hermitian semidefinite
    maximize real(trace(Ai*F3))
    subject to 
%         if Al ~= 0
            trace(Al*F3)/(1-xi_2^2/mu) + mu*trace(F3) <= alpha;
%         else
%             mu*trace(F3) <= alpha;  
%         end
        trace(F3) <= P;
    %   
cvx_end
else
    F3 = zeros(dAnt,dAnt);
end
    % CHECK IF THERE IS AN INFEASIBLE SOLUTION FOR PREVIOUS MU (NAN)
    % IF THERE IS, THEN, BREAK OUT OF AO AND LET F=0 BY ITS DEFAULT
else 
    flag = 1;       %F3=F3*.01;
    F3 = zeros(dAnt,dAnt);
    break % BREAK OUT OF IF STATEMENT
end

if flag == 1
    break % BREAK OUT OF AO
end
  

%% FEASIBILITY CHECK
eigF3 = eig(F3) ; 
flaggg = 0;
cnttt = 0;
rankOneF3 = F3;
if length(eigF3(abs(eigF3)<1e-2 == 0)) > 1
    cnttt;
    [eigVec,eigVal] = eig(F3);
    [maxVal,idx] = max(diag(eigVal));
    rankOneF3 = maxVal*eigVec(:,idx)*eigVec(:,idx)';
    b = trace(Al*rankOneF3)/(1-xi_2^2/mu) + mu*trace(rankOneF3) - alpha;
    c = trace(rankOneF3) - P;
    if b <= 1e-3 && c <= 1e-3
        break
    end
    
    while flaggg == 0
        cnttt = cnttt + 1;
        if cnttt == 20
            rankOneF3 = zeros(dAnt,dAnt);
            break
        end
        [rankOneF3] = gaussRand(F3); 
        b = trace(Al*rankOneF3)/(1-xi_2^2/mu) + mu*trace(rankOneF3) - alpha;
        c = trace(rankOneF3) - P;
        if b <= 1e-3 && c <= 1e-3
            flaggg = 1;
        end
    end
end
F3 = rankOneF3;
%%

F3second = F3;

%% SECOND OPTMIZATION
if ~isnan(F3)
if F3 ~= 0
beta = (trace(Al*F3)-xi_2^2*trace(F3)-alpha)/trace(F3);     
end
cvx_begin quiet
    variable mu
    subject to
        if F3 ~= 0
        square_abs(mu+beta/2) <= real(beta^2/4-(xi_2^2*alpha)/trace(F3)); 
        end
        mu >= xi_2^2 + 1e-3;
cvx_end
    % CHECK IF THERE IS AN INFEASIBLE SOLUTION FOR PREVIOUS F (NAN)
    % IF THERE IS, THEN, BREAK OUT OF AO AND LET F=0 BY ITS DEFAULT
else 
    flag = 1;    
    F3 = zeros(dAnt,dAnt);
    break % BREAK OUT OF IF STATEMENT
end
if flag == 1
    break % BREAK OUT OF AO
end
end  % END OF WHILE
%% COUNT ITERATIONS
iters(csiErr,intrf,expr) = cnt3;


end