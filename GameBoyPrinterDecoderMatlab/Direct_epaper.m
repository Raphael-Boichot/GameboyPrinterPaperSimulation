% Raphaël BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be 4 colors maximum, which is the native output format in this
%project
%Must use black and white image as input
clear
clc
paper_color=4;% 4=pink, 3=blue, 2=yellow or 1=regular
%watermarking='Raphael BOICHOT 2021';
[ID]=get_unique_ID(8);
DateString = date;
BandW_image=imread('GameBoy pixel perfect 3 12-Aug-2021.png');
map=BandW_image(:,:,1);
C=unique(map);
switch length(C)
    case 4; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*168+(map==C(4))*255;
    case 3; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*255;    
    case 2; map=(map==C(1))*0+(map==C(2))*255;  
end;
[epaper, alpha]=epaper_packet(map,paper_color);
%imwrite(epaper,['GameBoy epaper ',DateString,'.png'],'Alpha',alpha,'Author',watermarking);
unique_ID=num2str(rand,16);
imwrite(epaper,['GameBoy epaper_',DateString,'_',ID,'.png'],'Alpha',alpha);
disp('Done !')
