% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% This script directly handle the Arduino from Matlab
% for any question : raphael.boichot@gmail.com
% for end of transmission, simply reboot the Arduino

clear
clc
disp('-----------------------------------------------------------')
disp('|Beware, this code is for Matlab ONLY !!!                 |')
disp('|Beware, this code is not yet compatible Matlab Mobile !!!|')
disp('|Reboot Arduino to end transmission                       |')
disp('-----------------------------------------------------------')
arduinoObj = serialport("COM4",115200,'TimeOut',3600); %set the Arduino com port here
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1);
set(arduinoObj, 'timeout',60);
flag=0;
 str='Packet Capture V3';
while flag==0
data = readline(arduinoObj);
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
data = readline(arduinoObj);
disp(data)
fprintf(fid,'%s\r\n',data);
    if not(isempty(strfind(data,str)));
        flag=1;
    end
end

fclose(serial(arduinoObj.Port)); 
fclose(fid);
disp('Normal termination, printing the images...')

run Main_Decoder.m
