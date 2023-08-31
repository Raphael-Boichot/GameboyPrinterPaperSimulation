% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be 4 colors maximum, which is the native output format in this
%project
%Must use black and white image as input

clear
clc
pkg load image
paper_color=1; %6=random, 5=purple, 4=pink, 3=regular blue, 2=regular yellow or 1=regular white
darkness=10; %1=lightest 10=darkest
scale_percentage=30; %100=full size, smaller values scale down image
nb_frames=10; %number of images in animated gif
BandW_image=imread('GameBoy pixel perfect.png');
map=BandW_image(:,:,1);
C=unique(map);
switch length(C)
    case 4; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*168+(map==C(4))*255;
    case 3; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*255;
    case 2; map=(map==C(1))*0+(map==C(2))*255;
end;

sourceborders = dir('Borders/*.png');
num_borders=numel(sourceborders);%number of border images in the library
num1=ceil(num_borders*rand);
num2=num1;
while num1==num2
    num2=ceil(num_borders*rand);
end

average_map=[];
for i=1:1:nb_frames
    disp(['Making frame ',num2str(i)])
    [epaper]=epaper_packet(map,paper_color,darkness,scale_percentage,num1,num2);
    average_map=cat(3,average_map,epaper);
    [imind,cm] = rgb2ind(epaper);
    if i==1
        imwrite(imind,cm,'Output.gif','gif', 'Loopcount',inf,'DelayTime',0.05);
    else
        imwrite(imind,cm,'Output.gif','gif','WriteMode','append','DelayTime',0.05);
    end
end

imwrite(uint8(mean(average_map,3)),'Output.png');
disp('Animation done !')
