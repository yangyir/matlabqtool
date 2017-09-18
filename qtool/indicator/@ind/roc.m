function [ rocVal ] = roc( ClosePrice, nDay )
% Rate of Change
% default nDay = 20

if ~exist('nDay','var'), nDay = 20; end

rocVal = ([nan(nDay, size(ClosePrice,2)); ClosePrice(1:end-nDay,:)]./ClosePrice -1)*100;

end

