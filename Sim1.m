%POZOR!!! Pred tem zazeni integral1.m!!!
CENTER=[0,0];
MIDRAD=120;
NUM_STEB=8;
centers= getCenters(CENTER,NUM_STEB,MIDRAD);

RSTEB=40;           %r stebra
MAX=200;           %meje racunanja
STEP=5;            %korak racunanja

%TODO:
%-barve
%-GUI
x = -MAX:STEP:MAX; 

[X,Y] = meshgrid(x,x); %y =x matrike racunanih tock
scalars=[];         %skalarne vrednosti 1
scalars2=[];        %skalarne vrednosti 2

xs=[];              %x matrika vrednosti vektorjev
ys=[];              %y matrika vrednosti vektorjev

xs2=[];              %x matrika vrednosti vektorjev
ys2=[];              %y matrika vrednosti vektorjev

%racunanje

for x=-MAX:STEP:MAX
    xrow=[];    %vrstica x vektorjev
    yrow=[];    %vrstica y vektorjev
    srow=[];
    
    xrow2=[];
    yrow2=[];
    srow2=[];
   for y=-MAX:STEP:MAX
        p=[x,y];    %trenutni polozaj
        vector=[0,0];
        vector2=[0,0];
        for (i=1:NUM_STEB)
            vectora = getVector(p,[centers(i,1),centers(i,2)],RSTEB,vr,vv./vr1); %racunanje vektorja
            vectorb = getVector(p,[centers(i,1),centers(i,2)],RSTEB,vr,vv); %racunanje vektorja
            vector2=vector2+vectorb;% sestevanje vektorjev
            vector=vector+vectora;
        end
        %dodajanje vektorja vrstici
        xrow=[xrow,vector(2)];
        yrow=[yrow,vector(1)]; 
        
        xrow2=[xrow2,vector2(2)];
        yrow2=[yrow2,vector2(1)]; 
        
        scalar=sqrt(vector(1)^2+vector(2)^2);
        scalar2=sqrt(vector2(1)^2+vector2(2)^2);
        srow=[srow,scalar];
        srow2=[srow2,scalar2];
   end
    %dodajanje vrstice matriki vektorjev
    xs=[xs;xrow];
    ys=[ys;yrow]; 
    scalars=[scalars;srow];
    
    xs2=[xs2;xrow2];
    ys2=[ys2;yrow2]; 
    scalars2=[scalars2;srow2];
end
figure(1)
contour(X,Y,scalars,100)
title('Rotational speed v_r')
colorbar;
hold on
quiver(X,Y,xs,ys) %risanje vektorjev
hold off

figure(2)
contour(X,Y,scalars2,100)
title('Tangential speed v_0')
colorbar;
hold on
quiver(X,Y,xs2,ys2) %risanje vektorjev
hold off

return;
