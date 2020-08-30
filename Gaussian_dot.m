function [y]=Gaussian_dot(x,y,sigma,misx,misy)
%We assume a bell curve fits the best the real "pixel" of a thermal printer
y=(1/sigma).*exp(-(x-10+misx).^2/sigma-(y-10+misy).^2/sigma);
