% Raphaël BOICHOT 15/06/2021 Game Boy printer emulator
% code can handle compression, palette tricks and multiple images
% for any question : raphael.boichot@gmail.com
% code can handle compression and multiple images
% update V3 to follow compatibility with https://github.com/mofosyne/arduino-gameboy-printer-emulator
clear
clc

% Here you enter some parameters
%------------------------------------------------------------------------
file='Entry_file.txt';% enter text file to decode
color_option=1; %1 for Black and white, 2 for Game Boy Color, 3 for Game Boy DMG
%4 for CGA
%------------------------------------------------------------------------
raw_image=[];
num_image=0;
fid = fopen(file,'r');

while ~feof(fid)
    a=fgets(fid);
    % str='88 33 01';
    % if not(isempty(strfind(a,str)))
    % disp('INIT command received')
    % end
    
    % str='88 33 0F';
    % if not(isempty(strfind(a,str)))
    % disp('STATUS command received')
    % end
    
    str='88 33 04';
    if not(isempty(strfind(a,str)))
        if a(13:17)=='00 00'
            disp('Empty DATA packet received')
        else
            disp('DATA packet to process received')
            packet=decode_packet(a);
            raw_image=[raw_image;packet];
            imagesc(raw_image);
            drawnow
        end
    end
    
    str='88 33 02';
    if not(isempty(strfind(a,str)))&&not(isempty(raw_image))
        disp('PRINT command received')
        [colored_image, margin]= color_packet(a,raw_image,color_option);
        [BandW_image, margin]= color_packet(a,raw_image,1);
        [epaper]=epaper_packet(BandW_image);
        disp(['The margin is ',num2str(margin), ' lines'])
        imagesc(epaper)
        if not(margin==0);
            num_image=num_image+1;
            epaper=imresize(epaper,0.3,'bilinear');
            imwrite(epaper,['GameBoy_epaper_',num2str(num_image),'.png'])
            imwrite(colored_image,['GameBoy_',num2str(num_image),'.png'])
            raw_image=[];
            colored_image=[];
        end
    end
    
    str='Timed Out';
    if not(isempty(strfind(a,str)))&&not(isempty(raw_image))
        disp('Timed Out received')
        num_image=num_image+1;
        imwrite(epaper,['GameBoy_epaper_',num2str(num_image),'.png'])
        imwrite(colored_image,['GameBoy_',num2str(num_image),'.png'])
        raw_image=[];
        colored_image=[];
        disp('Flush spooler by force')
    end
end

if not(isempty(raw_image))
    num_image=num_image+1;
    imwrite(epaper,['GameBoy_epaper_',num2str(num_image),'.png'])
    imwrite(colored_image,['GameBoy_',num2str(num_image),'.png'])
    raw_image=[];
    colored_image=[];
    disp('Flush spooler by force')
end
