function [X,Y,scalars,xs,ys] = getData(px,py,CENTER,MIDRAD, NUM_STEB,RSTEB,MAX,STEP)
    centers= getCenters(CENTER,NUM_STEB,MIDRAD);
    x = -MAX:STEP:MAX; 

    [X,Y] = meshgrid(x,x); %y =x matrike racunanih tock
    scalars=[];         %skalarne vrednosti 1

    xs=[];              %x matrika vrednosti vektorjev
    ys=[];              %y matrika vrednosti vektorjev

    %racunanje

    for x=-MAX:STEP:MAX
        xrow=[];    %vrstica x vektorjev
        yrow=[];    %vrstica y vektorjev
        srow=[];
       for y=-MAX:STEP:MAX
            p=[x,y];    %trenutni polozaj
            vector=[0,0];
            for (i=1:NUM_STEB)
                vectora = getVector(p,[centers(i,1),centers(i,2)],RSTEB,px,py); %racunanje vektorja
                vector=vector+vectora;
            end
            %dodajanje vektorja vrstici
            xrow=[xrow,vector(2)];
            yrow=[yrow,vector(1)]; 

            scalar=sqrt(vector(1)^2+vector(2)^2);
            srow=[srow,scalar];
       end
        %dodajanje vrstice matriki vektorjev
        xs=[xs;xrow];
        ys=[ys;yrow]; 

        scalars=[scalars;srow];
    end
end

