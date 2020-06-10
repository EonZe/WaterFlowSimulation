function v = getCenters(center, num, r)
% getCenters(center,num,r) - Get centers of pillars
% center=[x,y] - circle center
% num - number of pillars
% r - radius of circle - pillar distance from center
%
% Example: x=getCenters([0,0],8,120);
% Returns: v=[pillar_center1;pillar_center2...] - pillar center
    step = 360/num;
    v=[];
    for i=0:step:360
        if (i==360)
            break;
        end
        vector=[-r,0]* [cosd(i),-sind(i); sind(i),cosd(i)];
        v=[v;vector+center];
    end
end

