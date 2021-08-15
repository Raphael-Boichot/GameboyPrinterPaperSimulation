% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% This script directly handle the Arduino from Matlab
% for any question : raphael.boichot@gmail.com
% for end of transmission, simply reboot the Arduino

clear
clc
pkg load image
pkg load instrument-control
disp('-----------------------------------------------------------')
disp('|Beware, this code is for Octave ONLY                !!!  |')
disp('|Reboot Arduino to end transmission                       |')
disp('-----------------------------------------------------------')
arduinoObj = serialport("COM4",115200); %set the Arduino com port here
%configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);

set(arduinoObj, 'timeout',60);
flag=0;
 str='Packet Capture V3';
while flag==0
data = ReadToTermination(arduinoObj,char(10));
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
