function [ outData ] = rslvBMktInfo( rawData )
% resolve data pack sent by HengSheng port
% rawData is a uint8 vector;
% outData is a struct with specific field.
%%

% fieldName = {'tickTime','contractCode','preSquare','open','last',...
%              'buy1P','buy1V','sell1P','sell1V','high',...
%              'low','delta','volume','openInterest','amount',...
%              'upLimit','downLimit','exchType','preCloseDay','preOpenInterest'...
%              'closeDay','square'};
% % int = 0; double = -1; char = x (x>0)
% fieldType = [0,13,-1,-1,-1,...
%             -1,0,-1,0,-1,...
%             -1,-1,0,0,-1,...
%             -1,-1,3,-1,-1,...
%             -1,-1];
         
outData.tickTime       = typecast(rawData(1:4),'int32');
outData.contractCode   = char(rawData(5:17));
outData.preSquare      = typecast(rawData(21:28),'double');
outData.open           = typecast(rawData(29:36),'double');
outData.last           = typecast(rawData(37:44),'double');
outData.buy1P          = typecast(rawData(45:52),'double');
outData.buy1V          = typecast(rawData(53:56),'uint32');
outData.sell1P         = typecast(rawData(57:64),'double');
outData.sell1V         = typecast(rawData(65:68),'uint32');
outData.high           = typecast(rawData(69:76),'double');
outData.low            = typecast(rawData(77:84),'double');
outData.delta          = typecast(rawData(85:92),'double');
outData.volume         = typecast(rawData(93:96),'uint32');
outData.openInterest   = typecast(rawData(97:100),'uint32');
outData.amount         = typecast(rawData(101:108),'double');
outData.upLimit        = typecast(rawData(109:116),'double');
outData.downLimit      = typecast(rawData(117:124),'double');
outData.exchType       = char(rawData(125:127));
outData.preCloseDay    = typecast(rawData(129:136),'double');
outData.preOpenInterest= typecast(rawData(137:144),'double');
outData.closeDay       = typecast(rawData(145:152),'double');
outData.square         = typecast(rawData(153:160),'double');

end

