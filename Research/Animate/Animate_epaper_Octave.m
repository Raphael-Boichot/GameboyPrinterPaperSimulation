% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% direct epaper encoder from image
%image must be 4 colors maximum, which is the native output format in this
%project
%Must use black and white image as input

clear
clc
pkg load image

paper_color=3; %6=random, 5=purple, 4=pink, 3=regular blue, 2=regular yellow or 1=regular white
darkness=8; %1=lightest 10=darkest
scale_percentage=25; %100=full size, smaller values scale down image
nb_frames=24; %number of images in animated gif
BandW_image=imread('GameBoy_pixel_perfect_big.png');
[heigh,width,~]=size(BandW_image);

if width>360
  disp('Rescaling image')
  BandW_image=imresize(BandW_image,160/width,'nearest');
end

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
    [imind,cm] = rgb2ind(epaper);
    if i==1
        imwrite(imind,cm,'Animation.gif','gif', 'Loopcount',inf,'DelayTime',0.04,'Compression','bzip');
    else
        imwrite(imind,cm,'Animation.gif','gif','WriteMode','append','DelayTime',0.04,'Compression','bzip');
    end
end

disp('Animation done !')
