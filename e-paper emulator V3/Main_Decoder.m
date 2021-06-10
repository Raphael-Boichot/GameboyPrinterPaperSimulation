% Rapha�l BOICHOT 09/06/2021 Game Boy printer emulator
% code can handle compression, palette tricks and multiple images
% Note that Disney Tarzan Has an in-game palette bug
% for any question : raphael.boichot@gmail.com
% code can handle compression and multiple images
% update V3 to follow compatibility with https://github.com/mofosyne/arduino-gameboy-printer-emulator
clear
clc


% Here you enter some parameters
%------------------------------------------------------------------------
file='Entry_file.txt';% enter text file to decode
crap_mode=0; %1 for e-paper and pixel perfect, 0 for pixel perfect only;
color_option=1; %1 for Black and white, 2 for Game Boy Color, 3 for Game Boy DMG
%4 for CGA
%------------------------------------------------------------------------
fid = fopen(file,'r');
IMAGE=[];
output_image=[];
output_crap=[];
DATA=0;
PRINTER=0;
PRINTING=0;
CONTINUE=0;
while ~feof(fid)
a=fgets(fid);
str='88 33 01';
if not(isempty(strfind(a,str)))
disp('INIT COMMAND')
end

str='88 33 0F';
if not(isempty(strfind(a,str)))
disp('STATUS COMMAND')
end


str='88 33 04';
if not(isempty(strfind(a,str)))
disp('DATA PACKET RECEIVED')
DATA=1;
end

str='88 33 02';
if not(isempty(strfind(a,str)))
% We get the current palette here. Each packet could have it's own palette
PALETTE=dec2bin(hex2dec(a(25:26)),8);
disp(['The color palette is: ',a(25:26)])
if PALETTE=='00000000';PALETTE='11100100';end;
%3 = black, 2 = dark gray, 1 = light gray, 0 = white
COLORS=[bin2dec(PALETTE(7:8)), bin2dec(PALETTE(5:6))...
    bin2dec(PALETTE(3:4)), bin2dec(PALETTE(1:2))];
MARGIN=dec2bin(hex2dec(a(22:23)),8);
% the protocol assumes that a margin of 3, '11' in binary is the end of an image
% data are so printed as a new png file
if MARGIN(7:8)=='11'
disp('PRINT DATA TO A NEW FILE DUE TO MARGIN')
CONTINUE=0;
PRINTER=1;
PRINTING=PRINTING+1;
end
%If (margin=0), the 'PRNT' command just signals to print a subpart of the image
%the code continues stacking the sub-images in this case
if MARGIN(7:8)=='00'
disp('CONTINUE PRINTING')
PRINTER=1;
CONTINUE=1;
end

end

if DATA==1

    DATA_length=hex2dec([a(16:17),a(13:14)]);
    COMPRESSION=0;
    if a(10:11)=='01' 
        COMPRESSION=1;
        disp('COMPRESSED DATA');
    end
           
    if not(COMPRESSION==1)
    DATA_tiles=DATA_length/16;
    disp(['This packet contains ',num2str(DATA_length),' bytes and ',num2str(DATA_tiles),' tiles']);
    end
    
if COMPRESSION==1
    %in case on compression, I assume the decompressed data are 640 bytes
    %long, but it seems always the case.
    %if data are compressed, uncompressed data are generated before
    %decoding. 
    pos=19;
    byte_counter=0;
    b=num2str([]);
    while byte_counter<640
    command=hex2dec(a(pos:pos+1));
    if command>=128 %its a compressed run, read the next byte and repeat
        disp('Compressed Run')
        length_run=command-128+2;
        byte=a(pos+3:pos+4);
        for i=1:1:length_run
            b=[b,byte,' '];
        end
        byte_counter=byte_counter+length_run;
        pos=pos+6;

    end
    
    if command<128 %its a classical run, read the n bytes after
        disp('Uncompressed Run')
        length_run=command+1;
        byte=a(pos+3:pos+length_run*3+1);
        b=[b,byte,' '];
        byte_counter=byte_counter+length_run;
        pos=pos+length_run*3+3;
        
    end
    end
    a=b;
    %I force the value in case of compressed packet
    DATA_tiles=40;
end
    
    %make a compact hexadecimal phrase without the protocol, just the data
        
    if not (COMPRESSION==1)
    %I just extract the data, not the commands or checksum
    a=a(19:end);
    end
    
    PACKET_image_width=160;
    PACKET_image_height=8*DATA_tiles/20;
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
    byte1=dec2bin(hex2dec([a(pos),a(pos+1)]),8);
    pos=pos+3;
    byte2=dec2bin(hex2dec([a(pos),a(pos+1)]),8);
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
    DATA=0;
    %Stacking of data packets 
    IMAGE=[IMAGE;PACKET_image];
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
    
    if not(CONTINUE==1)
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


disp('End of decoding')  
