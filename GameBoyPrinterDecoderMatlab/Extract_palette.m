clc
clear

a=imread('Pixel_sample_3600dpi_contrast.png');
average=mean(a,2);
average_LG=round(mean(average(45:55,:)));
average_DG=round(mean(average(25:35,:)));
average_B=round(mean(average(5:15,:)));
disp([255 255 255 average_LG average_DG average_B])
