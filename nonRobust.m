function [F,F2] = nonRobust(P,Hii,dAnt,alpha,Hli,Hll)

 %OPTIMIZATION AT THE UNLICENSED USER
cvx_begin quiet
    variable F(dAnt,dAnt) hermitian semidefinite
    maximize real(trace(Hii*Hii'*F))
    subject to
        real(trace(F)) <= P;
        if Hli ~= 0
        real(trace(Hli*Hli'*F)) <= alpha*1;
        end
cvx_end

rankOneF = F;
if ~isnan(F)
eigF = eig(F);
flag = 0;
cnttt = 0;
rankOneF = F;
if length(eigF(abs(eigF)<1e-2 == 0)) > 1
    while flag == 0
        cnttt = cnttt + 1;
        if cnttt == 10
            rankOneF = zeros(dAnt,dAnt);
            break
        end
        [rankOneF] = gaussRand(F); 
        b = real(trace(Hli*Hli'*F)) - alpha;
        c = trace(rankOneF) - P;
        if b <= 1e-2 && c <= 1e-5
            flag = 1;
        end
    end
end
end
F = rankOneF;


    % OPTIMIZATION AT THE LICENSED USER
%     if Hll ~= 0
cvx_begin quiet
    variable F2(dAnt,dAnt) hermitian semidefinite
    if Hll ~= 0
    maximize real(trace(Hll*Hll'*F2))
    end
    subject to
        real(trace(F2)) <= P;
cvx_end
%     else
%         F2 = zeros(dAnt,dAnt);
%     end

if ~isnan(F2)
eigF2 = eig(F2);   
flag = 0;
cnttt = 0;
rankOneF2 = F2;
if length(eigF2(abs(eigF2)<1e-2 == 0)) > 1
    while flag == 0
        cnttt = cnttt + 1;
        if cnttt == 10
            rankOneF2 = zeros(dAnt,dAnt);
            break
        end
        [rankOneF2] = gaussRand(F2); 
        c = trace(rankOneF2) - P;
        if c <= 1e-5
            flag = 1;
        end
    end
end
end
F2 = rankOneF2;


if isnan(F)
    F = zeros(dAnt,dAnt);
end

if isnan(F2)
    F2 = zeros(dAnt,dAnt);
end

end