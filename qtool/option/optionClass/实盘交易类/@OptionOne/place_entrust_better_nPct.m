function [e] = place_entrust_better_nPct(obj, direc, volume,  nPct, offset)
% �µ��������ü۸��ò��İٷֱ�
% [e] = place_entrust_better_nPct(obj, direc, volume, offset, nPct)
% nPct ��ȡ��0,100%������
% ask �� bid ��Ϊ100%�� ��
%����: bid 0%, ...,  ask 100%, ...
%  ����ask 0%, ...,  bid 100%, ...
% ---------------------
% cg�� 20160405

quote = obj.quote;

if ~exist('nTick', 'var')
    nPct = 0.50;
end

% TODO: autoOffset
if ~exist('offset', 'var')
    offset = 1;  % ����
end


%% main
a = quote.askP1;
b = quote.bidP1;
abs = a - b;

switch direc
    case{'1', 1, 'b', 'buy'}
        px = b + nPct * abs;
    case{'2', -1, 's', 'sell'}
        px  = a - nPct * abs;
end

e = obj.place_entrust_opt(direc, volume, offset, px);

end