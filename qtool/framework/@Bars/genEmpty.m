function   [ newbars] = genEmpty( length)
% �����̶����ȵĿ�Bars�������Ͽɿ���һ��constructor
% ---------------------------------------
% �̸� 20130920 V1.0

%% 
newbars         = Bars;


newbars.len     = length;
newbars.latest  = 0;

newbars.time    = nan(length,1);
newbars.time2   = nan(length,1);
newbars.open    = nan(length,1);
newbars.close   = nan(length,1);
newbars.high    = nan(length,1);
newbars.low     = nan(length,1);
newbars.amount  = nan(length,1);
newbars.volume  = nan(length,1);
newbars.vwap    = nan(length,1);
newbars.openInt = nan(length,1);


end

