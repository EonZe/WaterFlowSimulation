function [vector] = getVector(p,c,r,sx,sy)
% getVector(p,c,r,sx,sy) - Calculates vector from provided data
% p=[x,y] - vector origin
% c=[x,y] - pillar center
% r - pillar radius
% sx=[...] - x values for interpolation
% sy=[...] - y values for interpolation
%
% Example: x=getVector([x,y],[0,0],40,[...],[...]);
% Returns: vector=[x,y] - calculated vector

x=p(1);
y=p(2);

%polozaj centra
cx=c(1);
cy=c(2);

%razdalja od centra
l=sqrt((x-cx)^2+(y-cy)^2);

%skalar vektorja
scalar = interp1(sx, sy, l-r)/l;

%smer vektorja
v= (p-c);
%zasuk za 90 stopinj
vector=[v(2),-v(1)];

%prireditev skalarja vektorju
vector =scalar*vector;
end

