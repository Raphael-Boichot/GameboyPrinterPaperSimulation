% Raphaël BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be 4 colors maximum, which is the native output format in this
%project
%Must use black and white image as input
clear
clc

DateString = date;
BandW_image=imread('BBY_0001.png');
map=BandW_image(:,:,1);
C=unique(map);
switch length(C)
    case 4; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*168+(map==C(4))*255;
    case 3; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*255;    
    case 2; map=(map==C(1))*0+(map==C(2))*255;  
end;
[epaper]=epaper_packet(map);
epaper=imresize(epaper,0.3,'bilinear'); % this improves visual aspect
imwrite(epaper,['GameBoy epaper ',DateString,'.png'])
disp('Done !')