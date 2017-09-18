function [ moment ] = hpm(data,MAR,order)
%% Calculate ORDER order higher partial moments(HPM) of DATA at a minimum 
% acceptable return (MAR) level.
% DATA is a return sequence.
%%
margin = data - MAR;
margin(margin<0) = 0;
highMargin = margin;
moment = sum(highMargin.^order)/size(data,1);
end