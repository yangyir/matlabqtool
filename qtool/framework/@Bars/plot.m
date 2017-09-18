function [ output_args ] = plot( obj)
%plot »­ K Chart with high low open close
%   range         vector, АэИз[5:100]
% --------------------------------------------
% ver1.0;   Cheng,Gang;     20130404  


    candle(obj.high, obj.low, obj.close, obj.open );




end

