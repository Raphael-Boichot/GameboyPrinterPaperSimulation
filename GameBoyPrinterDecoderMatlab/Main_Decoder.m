% Raphaël BOICHOT 10/08/2021 Game Boy printer emulator
% code can handle compression, palette tricks and multiple images
% for any question : raphael.boichot@gmail.com
% update V3 to follow compatibility with https://github.com/mofosyne/arduino-gameboy-printer-emulator
clear
clc

% Here you enter some parameters
%------------------------------------------------------------------------
file='Entry_file.txt';% enter text file to decode
color_option=1; %1 for Black and white, 2 for Game Boy Color, 3 for Game Boy DMG, 4 for CGA
continuous_printing=0;  %0 to separate images automatically if margin >0
                        %1 for continuous printing with TimeOut or Manual dode, ignore margin > 0);
%------------------------------------------------------------------------


DateString = date;
raw_image=[];
num_image=0;
colored=[];
colored_image=[];
BandW=[];
BandW_image=[];
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
        [colored, margin]= color_packet(a,raw_image,color_option);
        colored_image=[colored_image;colored];
        [BandW, margin]= color_packet(a,raw_image,1);
        BandW_image=[BandW_image;BandW];
        [epaper]=epaper_packet(BandW_image);
        disp(['The after margin is 0x',num2str(dec2hex(margin))])
        imagesc(epaper)
        raw_image=[];
        if not(margin==0)&&not(continuous_printing);
            num_image=num_image+1;
            epaper=imresize(epaper,0.3,'bilinear');
            imwrite(epaper,['GameBoy e-paper ',num2str(num_image),' ',DateString,'.png'])
            imwrite(colored_image,['GameBoy pixel perfect ',num2str(num_image),' ',DateString,'.png'])
            raw_image=[];
            colored_image=[];
            colored=[];
            BandW=[];
            BandW_image=[];
        end
    end
    
    str='Timed Out';
    if not(isempty(strfind(a,str)))&&not(isempty(colored_image))&&(continuous_printing)
        disp('Cut paper command received')
        num_image=num_image+1;
        imwrite(epaper,['GameBoy e-paper ',num2str(num_image),' ',DateString,'.png'])
        imwrite(colored_image,['GameBoy pixel perfect ',num2str(num_image),' ',DateString,'.png'])
        raw_image=[];
        colored_image=[];
        colored=[];
        BandW=[];
        BandW_image=[];
        disp('Flush spooler by force')
    end
end

if not(isempty(colored_image))
    num_image=num_image+1;
    imwrite(epaper,['GameBoy e-paper ',num2str(num_image),' ',DateString,'.png'])
    imwrite(colored_image,['GameBoy pixel perfect ',num2str(num_image),' ',DateString,'.png'])
    raw_image=[];
    colored_image=[];
    colored=[];
    BandW=[];
    BandW_image=[];
    disp('Flush spooler by force')
end
fclose(fid);