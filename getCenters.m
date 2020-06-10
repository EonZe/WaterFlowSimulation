function v = getCenters(center, num, r)
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

