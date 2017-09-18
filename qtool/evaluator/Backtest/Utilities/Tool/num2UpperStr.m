function [ upperStr ] = num2UpperStr( num )
%NUM2UPPERCHAR Summary of this function goes here
%   Detailed explanation goes here
%%
x = mod(num-1,26);
y = floor((num-x-1)/26);
if y==0
    upperStr = char(x+65);
elseif y<=26
    upperStr = [char(y+64),char(x+65)];
else
    upperStr = [num2UpperStr(y),char(x+65)];
end

end

