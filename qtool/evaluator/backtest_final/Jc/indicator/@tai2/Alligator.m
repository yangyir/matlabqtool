function [sig_long, sig_short] = Alligator(bar, fast, mid, slow, delta, type)
%����alligator�����Լ���Ӧ�Ľ����ź�(-1,0,1)
%���� 
%�����ݡ�ClosePrice,HighPrice
%�������� �о���Ըߵ͵���ֵdelta=0.01;
% ��� 
%pos �����źţ��Լ�alligator��������ֵ linegreen linered lineblue �ֱ�Ϊ 5�� 8�� 13��sma
%   Yan Zhang   version 1.0 2013/3/12
%
%��ʱС���߱���ʱ�������Ը߳�һ����ֵ��sig_long�ź�Ϊ1
%��ʱ����߱���ʱС������Եͳ�һ����ֵ, sig_short�ź�Ϊ-1
%Yan Zhang   version 1.1 2013/3/21

% Ԥ����
if ~exist('delta','var') || isempty(delta), delta = 0.01; end
if ~exist('type','var') || isempty(type), type = 1; end
if ~exist('fast', 'var') || isempty(fast), fast = 3; end
if ~exist('mid', 'var') || isempty(mid), mid = 7; end
if ~exist('slow', 'var') || isempty(slow), slow = 15; end

highPrice = bar.high;
lowPrice = bar.low;
closePrice = bar.close;

[sig_long, sig_short] = tai.Alligator(highPrice,lowPrice,closePrice, fast, mid, slow, delta,type);


if nargout == 0
    [alligatorline.linegreen, alligatorline.linered, alligatorline.lineblue] = ...
        ind.alligator(highPrice, lowPrice, fast, mid, slow);
    bar.plotind2(sig_long + sig_short, alligatorline);
end

end

