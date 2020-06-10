[X,Y] = meshgrid(-2:0.2:2);
Z = X .* exp(-X.^2 - Y.^2);
contour(X,Y,Z,10)
[U,V] = gradient(Z,0.2,0.2);
hold on
quiver(X,Y,U,V)
hold off