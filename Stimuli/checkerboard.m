function im = checkerboard(size, armsR, armsT, cont, mask, sd, inverted, back)
% size = size of the checkerboard, pixel;
% armsR = numbers of sectors along the radius [1,2,3,4.....];
% armsT = numbers of sectors along the theta (circle) [1,2,3,4.....];
% cont = contrast of the checkerboard [0,1];
% mask = 1: no mask
%        2: gaussian mask;
% sd = standard deviation of the gaussian;
% inverted = invert the contrast of the mask, either -1 or 1;
% run = "imshow(checkerboard(300,4,5,1,1,0.25,1)/255);"

hiIndex = back + back * cont ;
loIndex = back - back * cont ;
bgIndex = back ;
xySize = size ;
xyLim = pi;

[x,y] = meshgrid(-xyLim:2*xyLim/(xySize-1):xyLim, ...
    -xyLim:2*xyLim/(xySize-1):xyLim) ;

[theta, rho] = cart2pol(x,y);

checks = inverted.*sign(sin((theta*armsT))+eps) .* ...  $ sign circular checkerboard 
    sign(sin(rho*armsR)+eps);
if loIndex == hiIndex
    checks (:,:) = bgIndex;
else
    checks = scaleif(checks, loIndex, hiIndex);
end

switch mask
    case 1
        circle = x.^2 + y.^2 <= xyLim^2 ;
        checks = circle .* checks + bgIndex * ~circle ;
        im = checks ;
    case 2
        xMask = -xyLim:2*xyLim/(xySize-1):xyLim;
        yMask= (1/sqrt(2*pi*sd)).*exp(-.5*((xMask/sd).^2));
        yMask= yMask ./ (max( yMask ));
        gaussianCircle = yMask' * yMask;
        checksFiltered = gaussianCircle .* checks;
        checksFiltered = scaleif(checksFiltered,bgIndex,hiIndex);
        im = checksFiltered ;
   
end
