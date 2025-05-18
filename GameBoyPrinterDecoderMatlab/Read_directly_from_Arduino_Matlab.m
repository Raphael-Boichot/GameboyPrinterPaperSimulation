% Raphael BOICHOT 11/08/2021 Game Boy printer emulator
% This script directly handle the Arduino from Matlab
% for any question : raphael.boichot@gmail.com
% for end of transmission, simply reboot the Arduino
warning('off')
clear
clc
disp('-----------------------------------------------------------')
disp('|Beware, this code is for Matlab ONLY !!!                 |')
disp('|Beware, this code is not yet compatible Matlab Mobile !!!|')
disp('|Reboot Arduino to end transmission                       |')
disp('-----------------------------------------------------------')
rng('shuffle');
list = serialportlist;
valid_port=[];
protocol_failure=1;
for i =1:1:length(list)
    disp(['Testing port ',char(list(i)),'...'])
    arduinoObj = serialport(char(list(i)),115200,'TimeOut',2);
    flush(arduinoObj);
    response=readline(arduinoObj);
    if ~isempty(response)
        if not(isempty(strfind(response,'GAMEBOY PRINTER')))
            disp(['Arduino detected on port ',char(list(i))])
            valid_port=char(list(i));
            beep ()
            protocol_failure=0;
        end
    end
    clear arduinoObj
end
if protocol_failure==0
    arduinoObj = serialport(valid_port,115200,'TimeOut',3600); %set the Arduino com port here
    configureTerminator(arduinoObj,"CR/LF");
    flush(arduinoObj);
    arduinoObj.UserData = struct("Data",[],"Count",1);
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
else
    disp('Arduino not detected')
end
