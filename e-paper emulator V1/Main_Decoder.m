% Raphaël BOICHOT 23-08-2020 Game Boy printer emulator
% code can handle compression, palette tricks and multiple images
% Note that Disney Tarzan Has an in-game palette bug
% https://github.com/mofosyne/arduino-gameboy-printer-emulator
% for any question : raphael.boichot@gmail.com
clc;
clear;
global color_option
global crap_mode
global file
% Here you enter some parameters
%------------------------------------------------------------------------
file='Entry_file.txt';% enter text file to decode
crap_mode=1; %1 for e-paper and pixel perfect, 0 for pixel perfect only;
color_option=1; %1 for Black and white, 2 for Game Boy Color, 3 for Game Boy DMG
%------------------------------------------------------------------------
fid = fopen(file,'r');
a=fgets(fid);
fclose(fid); 
if not(isempty(strfind(a,'Packet')))
disp('Decoding in raw packet mode')    
Arduino_Game_Boy_Printer_decoder_raw_mode();
else
disp('Decoding in default parse mode')    
Arduino_Game_Boy_Printer_decoder_parse_mode();  
end
disp('End of decoding')  

