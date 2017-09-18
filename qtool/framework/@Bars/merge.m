function [obj] = merge(obj,bs2)
% ��ƴ������Bars
% ����: û����֤ʱ��˳��,ֻ�Ǽ򵥵ذ�bs2�ӵ�obj��

% ��Ⱥ, 20131224;

if strcmp(obj.code, bs2.code) && strcmp(obj.type, bs2.type)
    obj.date    = [obj.date;    bs2.date];
    obj.open    = [obj.open;    bs2.open];
    obj.high    = [obj.high;    bs2.high];
    obj.low     = [obj.low;     bs2.low];
    obj.close   = [obj.close;   bs2.close];
    obj.preSettlement   = [obj.preSettlement;   bs2.preSettlement];
    obj.settlement      = [obj.settlement;      bs2.settlement];
    obj.time    = [obj.time;    bs2.time];
    obj.time2   = [obj.time2;   bs2.time2];
    obj.volume  = [obj.volume;  bs2.volume];
    obj.amount  = [obj.amount;  bs2.amount];
    obj.openInt = [obj.openInt; bs2.openInt];
    obj.tickNum = [obj.tickNum; bs2.tickNum];
else
    error('֤ȯ���Ͳ�һ����');
end
end