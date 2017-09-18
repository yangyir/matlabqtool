function [e] = place_entrust_better_nTicks(obj, direc, volume, nTick, offset)
% �µ������̿�n��
% -------------
% cg, 20160405

quote = obj.quote;
tick  = 0.0001;

if ~exist('nTick', 'var')
    nTick = 1;
end

% autoOffset
if ~exist('offset', 'var')
    offset = '1';  % ����
    switch direc
        case {'1', 1, 'b', 'buy'} % ��
            pos = obj.positionShort;
        case {'2', -1, 's', 'sell'} % ��
            pos = obj.positionLong;
    end
    
    % ����µ����ڳֲ֣��Ϳ��Թز�
    try
        if volume <= pos.volume
            offset = '2';
        end
    catch
    end
end


%% main

switch direc
    case{'1', 1, 'b', 'buy'}
        goodPx   = quote.bidP1;
        betterPx = goodPx + nTick * tick;
    case{'2', -1, 's', 'sell'}
        goodPx    = quote.askP1;
        betterPx  = goodPx - nTick * tick;
end

e = obj.place_entrust_opt(direc, volume, offset, betterPx);
end