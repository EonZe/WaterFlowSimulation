%POZOR!!! Pred tem zazeni integral1.m!!!
POS= [0,0];     %x,y osi stebra
POS2= [200,0];     %x,y osi stebra2
POS3= [120,200];     %x,y osi stebra3
RSTEB=50;       %r stebra
MAX=500;
x = -MAX:MAX;
y = x;

[X,Y] = meshgrid(-MAX:MAX,-MAX:MAX);
Z1 = interp1(vr,vv,abs(sqrt((X-POS(1)).^2+(Y-POS(2)).^2))-20);
Z2 = interp1(vr,vv,abs(sqrt((X-POS2(1)).^2+(Y-POS2(2)).^2))-20);
Z3 = interp1(vr,vv,abs(sqrt((X-POS3(1)).^2+(Y-POS3(2)).^2))-20);
Z=Z1-Z2+Z3;

