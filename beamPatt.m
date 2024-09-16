function [beamPatt] = beamPatt(bsAnt,theta,ratio,F)
    steerVec = [];
    for n = 0:bsAnt-1
        steerVec = [steerVec; exp(n*1i*2*pi*ratio*sin(deg2rad(theta)))];
    end
    beamPatt = real(trace(steerVec*steerVec'*F));
end