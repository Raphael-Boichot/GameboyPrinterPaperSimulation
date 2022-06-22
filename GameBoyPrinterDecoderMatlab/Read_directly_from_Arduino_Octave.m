% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% This script directly handle the Arduino from Matlab
% for any question : raphael.boichot@gmail.com
% for end of transmission, simply reboot the Arduino

clear
clc
disp('-----------------------------------------------------------')
disp('|Beware, this code is for GNU Octave ONLY !!!             |')
disp('|Beware, this code is not yet compatible Matlab Mobile !!!|')
disp('|Reboot Arduino to end transmission                       |')
disp('|If no transmission, set GBP_SO_PIN to 5 in Arduino code  |')
disp('-----------------------------------------------------------')
pkg load image
pkg load instrument-control
arduinoObj = serialport("COM4",'baudrate',115200,'timeout',-1); %set the Arduino com port here
%configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);

set(arduinoObj, 'timeout',-1);
flag=0;
str='Packet Capture V3';
while flag==0
data = ReadToTermination(arduinoObj);
disp(data)
    if not(isempty(strfind(data,str)))
        flag=1;
    end
end

disp('Entering the capture loop...')
fid=fopen('Entry_file.txt','w');
str='Packet Capture V3';
flag=0;
while flag==0
data = ReadToTermination(arduinoObj);
disp(data)
fprintf(fid,'%s\r\n',data);
    if not(isempty(strfind(data,str)));
        flag=1;
    end
end

fclose(fid);
disp('Normal termination, printing the images...')

run Main_Decoder.m
