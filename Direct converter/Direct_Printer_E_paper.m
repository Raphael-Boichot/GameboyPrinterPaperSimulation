% Raphael BOICHOT 25/11/2021 E-paper module for NeoGB printer
% Compatible with Matlab and Octave
% image must be 4 colors maximum, which is the native output format 

clear
clc
paper_color=1;%6=random, 5=purple, 4=pink, 3=regular blue, 2=regular yellow or 1=regular white
%watermarking='Raphael BOICHOT 2021';

  try
    pkg load image % for compatibility with Octave
  catch 
    % Nothing to do
  end
  
mkdir E_paper
imagefiles = dir('./Image_in/*.png');% the default format is png, other are ignored
nfiles = length(imagefiles);    % Number of files found

for k=1:1:nfiles
    currentfilename = imagefiles(k).name;
    BandW_image=imread(['./Image_in/',currentfilename]);
map=BandW_image(:,:,1);
C=unique(map);
switch length(C)
    case 4; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*168+(map==C(4))*255;
    case 3; map=(map==C(1))*0+(map==C(2))*84+(map==C(3))*255;    
    case 2; map=(map==C(1))*0+(map==C(2))*255;  
end;
[epaper, alpha]=epaper_packet(map,paper_color);
imwrite(epaper,['./Paper_out/GameBoy epaper_',currentfilename],'Alpha',alpha);
disp(['GameBoy_epaper_',currentfilename,' written to SD Card'])
end
disp('Done !')

