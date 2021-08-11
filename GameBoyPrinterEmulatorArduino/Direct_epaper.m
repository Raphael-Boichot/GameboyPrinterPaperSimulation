% Raphaël BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be [0 84 168 255], which is the native output format in this
%project
%Must use black and white image as input
clear
clc

DateString = date;
BandW_image=imread('GameBoy pixel perfect 1 10-Aug-2021.png');
[epaper]=epaper_packet(BandW_image);
epaper=imresize(epaper,0.3,'bilinear'); % this improves visual aspect
imwrite(epaper,['GameBoy pixel perfect ',DateString,'.png'])
disp('Done !')