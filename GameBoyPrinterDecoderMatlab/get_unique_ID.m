function [ID]=get_unique_ID(number_digits)
library='abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
for i=1:1:number_digits
    ID(i)=library(ceil(rand*62));
end