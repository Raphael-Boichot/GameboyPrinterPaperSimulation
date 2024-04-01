function [colored_image,margin]=color_packet(a,raw_image,color_option)

% We get the current palette here. Each packet could have it's own palette
PALETTE=dec2bin(hex2dec(a(25:26)),8);
disp(['The color palette is 0x',a(25:26)])
if PALETTE=='00000000';PALETTE='11100100';end;
%3 = black, 2 = dark gray, 1 = light gray, 0 = white
COLORS=[bin2dec(PALETTE(7:8)), bin2dec(PALETTE(5:6))...
    bin2dec(PALETTE(3:4)), bin2dec(PALETTE(1:2))];
%margin=hex2dec(a(22:23));
margin=hex2dec(a(23));
%create your palette here
%(R G B for white) (R G B for light gray) (R G B for dark gray) (R G B for black)
colors=[255 255 255 168 168 168 84 84 84 0 0 0;% 1 = Black and white
    215 247 215 130 222 73 6 75 145 0 19 26;% 2 = Game Boy Color
    123 130 16 90 121 66 57 89 74 41 65 57;% 3 = Game Boy DMG
    255 255 255 89 255 252 239 42 248 0 0 0;% 4 = CGA
    255 255 255 255 128 128 128 64 64 0 0 0];% 5 = Salmon

[h, w, ~]=size(raw_image);

frame=zeros(h, w, 3);
%now we swap the palette, as palette may vary.
for j=1:1:h
    for k=1:1:w
        raw_image(j,k)=COLORS(raw_image(j,k)+1);
    end
end

%now we colorize the image in RGB true colors
for j=1:1:h
    for k=1:1:w
        
        if raw_image(j,k)==0;
            frame(j,k,:)=colors(color_option,1:3);
        end
        if raw_image(j,k)==1;
            frame(j,k,:)=colors(color_option,4:6);
        end
        if raw_image(j,k)==2;
            frame(j,k,:)=colors(color_option,7:9);
        end
        if raw_image(j,k)==3;
            frame(j,k,:)=colors(color_option,10:12);
        end
        
        
    end
end
%converts double into 8 bits integers
colored_image=uint8(frame);