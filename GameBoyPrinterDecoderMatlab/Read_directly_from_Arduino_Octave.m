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
disp('-----------------------------------------------------------')
pkg load image
pkg load instrument-control


list = serialportlist;
valid_port=[];
protocol_failure=1;
for i =1:1:length(list)
    disp(['Testing port ',char(list(i)),'...'])
    s = serialport(char(list(i)),'BaudRate',115200);
    set(s, 'timeout',2);
    flush(s);
    response=char(read(s, 100));
    if ~isempty(response)
        if strcmp(response(4:18),'GAMEBOY PRINTER')
            disp(['Arduino detected on port ',char(list(i))])%last char is ACK
            valid_port=char(list(i));
            beep ()
            protocol_failure=0;
        end
    end
    clear s
end

if protocol_failure==0
    arduinoObj = serialport(valid_port,'baudrate',115200,'timeout',-1); %set the Arduino com port here
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
else
    disp('Arduino not detected')
end
