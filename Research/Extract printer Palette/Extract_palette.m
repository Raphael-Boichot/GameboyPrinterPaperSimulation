clc
clear

a=imread('Pixel_sample_3600dpi_contrast.png');
palette=[];
startx=5;
starty=5;

for j=0:1:2 %scan the 3 pixel intensity
    accumulator=zeros(10,10,3);
    for i=0:1:49 %scan 50 pixels, 20x20, take the 10x10 inner zone only
        accumulator=accumulator+double(a(starty+20*j:starty+20*j+9,startx+20*i:startx+20*i+9,:));
    end
    accumulator=accumulator/50;
    accumulator=uint8(mean(mean(accumulator)));
    palette=[palette;accumulator];
end

palette = permute(palette,[2 3 1])
disp([255 255 255 palette(:,:,3) palette(:,:,2) palette(:,:,1)])
