function [idx] = findNearest(locs,user,radius)
    a = locs-user;
    dist = (a(:,1).^2 + a(:,2).^2).^(0.5);
    idx = find(dist <= radius);
end
