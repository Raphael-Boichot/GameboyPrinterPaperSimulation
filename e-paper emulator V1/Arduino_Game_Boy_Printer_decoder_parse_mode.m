% Raphaël BOICHOT 23-08-2020 Game Boy printer emulator
% code can handle compression and multiple images
% Parse mode only translates 'p'
% https://github.com/mofosyne/arduino-gameboy-printer-emulator
function []=Arduino_Game_Boy_Printer_decoder_parse_mode()
global color_option
global crap_mode
global file
%------------------------------------------------------------------------
fid = fopen(file,'r');
IMAGE=[];
output_image=[];
output_crap=[];
DATA=0;
PRINTER=0;
PRINTING=0;
CONTINUE=0;
a_parse=[];
NEW_READ=1;
while ~feof(fid)
if NEW_READ==1    
a=fgets(fid);
end
str='INIT';
if not(isempty(strfind(a,str)))
disp('INIT COMMAND')
end

str='DATA';
if not(isempty(strfind(a,str)))
disp('DATA PACKET RECEIVED')
DATA=1;

if a(strfind(a,'more')+6)=='0'
disp('EMPTY PACKET')
a=fgets(fid);
DATA=0;
end

end

str='PRNT';
NEW_READ=1;
if not(isempty(strfind(a,str)))
% We get the current palette here. Each packet could have it's own palette
PALETTE=dec2bin(str2double(a(strfind(a,'pallet')+8:strfind(a,'pallet')+10)),8);
if PALETTE==0;PALETTE=228;end;
%3 = black, 2 = dark gray, 1 = light gray, 0 = white
COLORS=[bin2dec(PALETTE(7:8)), bin2dec(PALETTE(5:6))...
    bin2dec(PALETTE(3:4)), bin2dec(PALETTE(1:2))];
% the protocol assumes that a margin of 3, '11' in binary is the end of an image
% data are so printed as a new png file
MARGIN=a(strfind(a,'margin_lower')+14);
if MARGIN=='3'
disp('PRINT DATA TO A NEW FILE DUE TO MARGIN')
CONTINUE=0;
PRINTER=1;
PRINTING=PRINTING+1;
end
%If (margin=0), the 'PRNT' command just signals to print a subpart of the image
%the code continues stacking the sub-images in this case
if MARGIN=='0'
disp('CONTINUE PRINTING')
PRINTER=1;
CONTINUE=1;
end

end

if DATA==1
    %extract data packet
    DATA_length=640;
    COMPRESSION=0;
    if a(strfind(a,'compressed')+12)=='1' 
        COMPRESSION=1;
        disp('COMPRESSED DATA');
    end
           
    if not(COMPRESSION==1)
    DATA_tiles=DATA_length/16;
    disp('UNCOMPRESSED DATA');
    disp(['This packet contains ',num2str(DATA_length),' bytes and ',num2str(DATA_tiles),' tiles']);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if COMPRESSION==1
    %in case on compression, I assume the decompressed data are 640 bytes
    %long, but it seems always the case.
    %if data are compressed, uncompressed data are generated before
    %decoding. 
    a_parse=num2str([]);
    a=fgets(fid);
    while(isempty(strfind(a,'{')))
    a_parse=[a_parse,a(1:end-1),' '];
    a=fgets(fid);
    end
    NEW_READ=0;
    
    pos=1;
    byte_counter=0;
    b=num2str([]);
    while byte_counter<640
    command=hex2dec(a_parse(pos:pos+1));
    if command>128 %its a compressed run, read the next byte and repeat
        %disp('Compressed Run')
        length_run=command-128+2;
        byte=a_parse(pos+3:pos+4);
        for i=1:1:length_run
            b=[b,byte,' '];
        end
        byte_counter=byte_counter+length_run;
        pos=pos+6;

    end
    
    if command<128 %its a classical run, read the n bytes after
        %disp('Uncompressed Run')
        length_run=command+1;
        byte=a_parse(pos+3:pos+length_run*3+1);
        b=[b,byte,' '];
        byte_counter=byte_counter+length_run;
        pos=pos+length_run*3+3;
        
    end
    end
    a_parse=b;
    %I force the value in case of compressed packet
    DATA_tiles=40;
end
    
    %make a compact hexadecimal phrase without the protocol, just the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    if not (COMPRESSION==1)
    %I made a single vector of of the 640 bytes
    a_parse=num2str([]);
    for i=1:1:40
    a=fgets(fid);
    a_parse=[a_parse,a(1:48)];
    end
    end
    PACKET_image_width=160;
    PACKET_image_height=16;
    PACKET_image=zeros(PACKET_image_height,PACKET_image_width);    
    pos=1;
    %tile decoder
    tile_count=0;
    height=1;
    width=1;
while tile_count<DATA_tiles    
    tile=zeros(8,8);
    for i=1:1:8
    %Surpringly, there's no native hex2bin function in Matlab, you have to stack
    %the two functions hex2dec, dec2bin
    byte1=dec2bin(hex2dec([a_parse(pos),a_parse(pos+1)]),8);
    pos=pos+3;
    byte2=dec2bin(hex2dec([a_parse(pos),a_parse(pos+1)]),8);
    pos=pos+3;
    
      for j=1:1:8
      tile(i,j)=bin2dec([byte2(j),byte1(j)]);
      end
    end
    PACKET_image((height:height+7),(width:width+7))=tile;
    tile_count=tile_count+1;
    width=width+8;
      %Images are always 160 pixels width, height varies only
      if width>=160
      width=1;
      height=height+8;     
      end
end
    %Stacking of data packets 
    IMAGE=[IMAGE;PACKET_image];
    a_parse=[];
    DATA=0;
end    


if PRINTER==1
[h, w, ~]=size(IMAGE);
frame=zeros(h, w, 3);
crap_frame=zeros(h, w);
%now we swap the palette, as palette may vary.
        for j=1:1:h
        for k=1:1:w
        IMAGE(j,k)=COLORS(IMAGE(j,k)+1);
        end
        end
        
%Frame for CrapPrinter undergoes a separate treattment    
        for j=1:1:h
        for k=1:1:w
        if IMAGE(j,k)==0; crap_frame(j,k,:)=255; end
        if IMAGE(j,k)==1; crap_frame(j,k,:)=168; end
        if IMAGE(j,k)==2; crap_frame(j,k,:)=84; end
        if IMAGE(j,k)==3; crap_frame(j,k,:)=0; end
        end
        end
        
%now we colorize the image in RGB true colors        
        for j=1:1:h
        for k=1:1:w
if color_option==1
        if IMAGE(j,k)==0; frame(j,k,:)=[255 255 255]; end
        if IMAGE(j,k)==1; frame(j,k,:)=[168 168 168]; end
        if IMAGE(j,k)==2; frame(j,k,:)=[84 84 84]; end
        if IMAGE(j,k)==3; frame(j,k,:)=[0 0 0]; end
end

if color_option==2
         if IMAGE(j,k)==3; frame(j,k,:)=[0 19 26];end
         if IMAGE(j,k)==2; frame(j,k,:)=[6 75 145]; end
         if IMAGE(j,k)==1; frame(j,k,:)=[130 222 73]; end
         if IMAGE(j,k)==0; frame(j,k,:)=[215 247 215]; end
end

if color_option==3
         if IMAGE(j,k)==3; frame(j,k,:)=[56 110 86];end
         if IMAGE(j,k)==2; frame(j,k,:)=[70 131 89]; end
         if IMAGE(j,k)==1; frame(j,k,:)=[93 150 78]; end
         if IMAGE(j,k)==0; frame(j,k,:)=[120 169 59]; end
end

if color_option==4
         if IMAGE(j,k)==3; frame(j,k,:)=[0 0 0];end
         if IMAGE(j,k)==2; frame(j,k,:)=[239 42 248]; end
         if IMAGE(j,k)==1; frame(j,k,:)=[89 255 252]; end
         if IMAGE(j,k)==0; frame(j,k,:)=[255 255 255]; end
end
        end
        end
    %converts double into 8 bits integers  
    frame=uint8(frame);
    output_image=[output_image;frame];
    output_crap=[output_crap;crap_frame];
    figure(1)
    imagesc(output_image)
    colormap(gray)
    pause(1)   
    
    if not(CONTINUE==1);
    if not(isempty(frame))
    disp('FLUSH PRINTER')
    imwrite(output_image,['Game_Boy_Pixel_perfect_',num2str(PRINTING),'.png'])
    if crap_mode==1
    disp('Creating e-paper image, be patient...')
    [crap]=Game_Boy_crap_me(output_crap);
    imwrite(crap,['Game_Boy_Printer_e-paper_',num2str(PRINTING),'.png']);    
    disp('Printing e-paper image')
    end  
    output_image=[];
    output_crap=[];
    end
    end
    
    PRINTER=0;
IMAGE=[];
end

end
% somes few games never send a margin of 3, so the prints have to be
% flushed at the end of transmission as a stripe of images.
if not(isempty(output_image))
    disp('FLUSH PRINTER BY FORCE')
    imwrite(output_image,['Game_Boy_Pixel_perfect_',num2str(PRINTING),'.png'])
    if crap_mode==1
    disp('Creating e-paper image, be patient...')
    [crap]=Game_Boy_crap_me(output_crap);
    imwrite(crap,['Game_Boy_Printer_e-paper_',num2str(PRINTING),'.png']);    
    disp('Printing e-paper image')
    end
end