% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be 4 colors maximum, which is the native output format in this
%project
%Must use black and white image as input
clear
clc
nb_frames=20; %number of images in animated gif
BandW_image=imread('hello_pixel_perfect.png');
map=BandW_image(:,:,1);
C=unique(map);
switch length(C)
    case 4; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*168+(map==C(4))*255;
    case 3; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*255;    
    case 2; map=(map==C(1))*0+(map==C(2))*255;  
end;

for i=1:1:nb_frames
    [epaper]=epaper_packet(map);
    [imind,cm] = rgb2ind(epaper,256);
    if i==1
        imwrite(imind,cm,'Output.gif','gif', 'Loopcount',inf,'DelayTime',0.05);
    else
        imwrite(imind,cm,'Output.gif','gif','WriteMode','append','DelayTime',0.05);
    end
end

imwrite(epaper,'Output.png');
disp('Done !')