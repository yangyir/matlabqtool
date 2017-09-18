function [ newbars ] = fixbase( obj, value )
%FIXBASE ���bars.open(1)���ж���������
%  value        ����������Ĭ��value = obj.vwap(1)

%% pre-process

if ~exist('value', 'var') value = obj.vwap(1); end

%% main
newbars = Bars;

% ������
newbars.type      = obj.type;
newbars.time      = obj.time;
newbars.volume    = obj.volume;
newbars.amount    = obj.amount;
newbars.openInterest = obj.openInterest;

%������
newbars.open  = obj.open  / value;
newbars.close = obj.close / value;
newbars.high  = obj.high  / value;
newbars.low   = obj.low   / value;
newbars.vwap  = obj.vwap  / value;


end

