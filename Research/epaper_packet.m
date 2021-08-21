function [output]=epaper_packet(input)
% Raphael BOICHOT 10-09-2020
% code to simulate the speckle aspect of real Game boy printer
% image come from function call

pixel_sample=imread('Pixel_sample_3600dpi_contrast.png');
num_borders=13;%number of border images in the library
num1=ceil(num_borders*rand);
num2=num1;
while num1==num2
    num2=ceil(num_borders*rand);
end

IMAGE=input;

mul=20;%size of the mask
overlapping=4;%overlapping

%intensity map for printer head with threshold
[heigth, width,~]=size(IMAGE);
streaks=zeros(heigth, width);
for i=1:1:width
  start=ceil(2*rand)-1;
  for j=1:1:heigth
  streaks(j,i)=start;
  %you can change the streak length here
  if rand<0.2;start=ceil(2*rand)-1;end;
  end
end


speckle_image=uint8(255*ones(heigth*(mul-overlapping)+overlapping,width*(mul-overlapping)+overlapping,3));

for i=1:1:heigth
   for j=1:1:width
       a=1+(i-1)*(mul-overlapping);
       b=a+mul-1;
       c=1+(j-1)*(mul-overlapping);
       d=c+mul-1;
       if IMAGE(i,j)==0
       y=0;
       x=ceil(49*rand);
       burn_dot=pixel_sample(1+20*y:20+20*y,1+20*x:20+20*x,:);
       end
       
       if IMAGE(i,j)==84
       y=1;
       x=ceil(49*rand);
       burn_dot=pixel_sample(1+20*y:20+20*y,1+20*x:20+20*x,:);
       end
       
       if IMAGE(i,j)==168
       y=2;
       x=ceil(49*rand);
       burn_dot=pixel_sample(1+20*y:20+20*y,1+20*x:20+20*x,:);
       end
            
       if not(IMAGE(i,j)==255);
       if rand<0.5; burn_dot=flip(burn_dot,ceil(2*rand));end;
       burn_dot=rot90(burn_dot,ceil(2*rand)-2);
       if streaks(i,j)==0; burn_dot=burn_dot+20;end;
       speckle_image(a:b,c:d,:)=min(burn_dot,speckle_image(a:b,c:d,:));
       end
end
end
%centering image on paper, The width of the print should be 27.09mm compared to the paper at 38mm

resize_ratio=0.2; %1 for full image, 0.3 for nice looking image
speckle_image=imresize(speckle_image,resize_ratio,'bilinear');

output=speckle_image;

