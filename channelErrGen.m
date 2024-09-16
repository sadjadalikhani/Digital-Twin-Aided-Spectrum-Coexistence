function [perfectH] = channelErrGen(H,percent,mode)
    [M,N] = size(H);
    if mode == 1 % WORST-CASE
        h = (unifrnd(-1,1,M,N) + sqrt(-1)* unifrnd(-1,1,M,N))/sqrt(2*N*M); %%%%%%% *N*M
        channelErr = h*norm(H,'fro')*percent;
        perfectH = H + channelErr;
    elseif mode == 2 % OUTAGE-CONSTRAINED
        h = (randn(M*N,1) + 1i*randn(M*N,1))/sqrt(2);
%         channelErr = h*norm(H,'fro')*percent;
        channelErr = h*norm(H,'fro')*max(normrnd(percent,0),0);
        channelErr = reshape(channelErr,M,N);
        perfectH = H + channelErr;
    end
end