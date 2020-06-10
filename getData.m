function [X,Y,scalars,xs,ys] = getData(px,py,CENTER,MIDRAD, NUM_STEB,RSTEB,MAX,STEP)
% getData(px,py,CENTER,MIDRAD, NUM_STEB,RSTEB,MAX,STEP) - Calculates
% required vectors and scalars - Provide all distance units in μm
% px=[...] - x values for interpolation
% py=[...] - y values for interpolation
% CENTER - pillars circle center
% num - number of pillars
% r - radius of circle - pillar distance from center
% RSTEB - pillar radius
% MAX - Calculation bounds: Calculates from [-MAX,-MAX] to [MAX,MAX]
% STEP - Calculation step
%
% Example: x=getData(1:10,2*(1:10),[0,0],120,8,40,200,5);
% Returns: [X,Y,scalars,xs,ys]
%   X,Y - meshgrid vectors (from -MAX to MAX)
%   scalars - scalar values of vectors - for colormap
%   xs, ys - x and y values of vectors
    centers= getCenters(CENTER,NUM_STEB,MIDRAD);
    x = -MAX:STEP:MAX; 

    [X,Y] = meshgrid(x); %y =x matrike racunanih tock
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

