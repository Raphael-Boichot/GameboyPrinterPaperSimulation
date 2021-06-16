function packet=decode_packet(a)
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
            %disp('Compressed Run')
            length_run=command-128+2;
            byte=a(pos+3:pos+4);
            for i=1:1:length_run
                b=[b,byte,' '];
            end
            byte_counter=byte_counter+length_run;
            pos=pos+6;
            
        end
        
        if command<128 %its a classical run, read the n bytes after
            %disp('Uncompressed Run')
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
packet=PACKET_image;