function [output]=Game_Boy_crap_me(input)
% Raphaël BOICHOT 16-08-2020
% code to simulate the speckle aspect of real Game boy printer
% image come from function call
IMAGE=input;
%choose the error rate on each printer dot
error_rate_printer_head=0.3;
%choose the error rate on each pixel
error_rate_brownian=0.25;
%Choose the lateral spreading of gaussian dot
sigma=30;
%Misalignement rate in pixels
mis=0.5;
%Head failure rate, simulatue dust on paper
failure=0.0025;

%Generate a printer dot with Gaussien function
x=1:1:20;
y=1:1:20;
[X,Y]=meshgrid(x,y);
%this is the mask that will be used
%Deactivvate comment to see the shape of printer function
% y=Gaussian_dot(X,Y,sigma,mis*rand,mis*rand);
intensity=(y-min(min(y)))/(max(max(y))-min(min(y)));
% figure(3)
% surf(y)

%Quantity of pixels for shifting the mask
mul=10;
intensity_map=1-double(IMAGE(:,:,1))/255;
min_int=min(min(intensity));
max_int=max(max(intensity));

%intensity map for printer head with threshold
[heigth, width,deepness]=size(IMAGE);

%calculate the misalignement table
mistablex=mis*rand(width);
mistabley=mis*rand(heigth);
speckle_image=zeros(heigth*mul+30,width*mul+30);
for i=1:1:heigth
   for j=1:1:width
       a=10+(i-1)*mul;
       b=19+i*mul;
       c=10+(j-1)*mul;
       d=19+j*mul;
       
       if not(intensity_map(i,j)==0)
       %apply the printer head misalignement
       y=Gaussian_dot(X,Y,sigma,mistabley(j)+2*mis*rand,mistablex(i)+2*mis*rand);
       intensity=(y-min(min(y)))/(max(max(y))-min(min(y)));
       
       %apply a failure rate
       if rand<failure;
           intensity=intensity.*0.5;
       end
       
       %apply the printer head error
       burn_dot=error_rate_printer_head*intensity*intensity_map(i,j)*abs(rand)...
           +(1-error_rate_printer_head)*intensity*intensity_map(i,j);
       error_mask=abs(rand(20,20));
       %apply individual pixel error;
       burn_dot=error_rate_brownian*burn_dot.*error_mask+(1-error_rate_brownian)*burn_dot;  
       speckle_image(a:b,c:d)=burn_dot+speckle_image(a:b,c:d);
       %speckle_image(a:b,c:d)=max(burn_dot,speckle_image(a:b,c:d));
       end
%         figure(1)
%         imagesc(speckle_image);
%         colormap(1-gray);
%         drawnow
   end
end

% disp('Blurring')
% %A bit of Gaussian Blur
% blur=zeros(heigth*mul+30-2,width*mul+30-2);
% for i=2:1:heigth*mul+30-1
%    for j=2:1:width*mul+30-1
%     blur(i-1,j-1)=(speckle_image(i,j+1)+speckle_image(i,j-1)+...
%         speckle_image(i+1,j)+speckle_image(i-1,j)+2*speckle_image(i,j))/6;
%    end
% end
blur=speckle_image;
%contrast enhancement
blur=blur./max(max(blur));
blur=uint8((1-blur)*255);
figure(1)
imagesc(blur);
colormap gray
output=blur;
pause(1)
