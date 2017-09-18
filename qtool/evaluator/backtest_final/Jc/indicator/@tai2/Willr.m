function [sig_long, sig_short] = Willr(bars, nday, thred1, thred2, type)
%����williamsֵ�Լ���Ӧ�Ľ����ź�(-1,0,1)
%���� ClosePrice,HighPrice,Lowprice,n,���У�n��ʾ���ڵĳ���
%��� pos �����źţ�willr �����willrֵ
%   Yan Zhang   version 1.0 2013/3/12

%willr>-20, ����״̬������������ź�Ϊ-1
%willr<-80, ����״̬��������ף��ź�Ϊ1 
%   Yan Zhang   version 1.1 2013/3/21
if ~exist('nday', 'var') || isempty(nday), nday = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

ClosePrice = bars.close;
HighPrice = bars.high;
LowPrice = bars.low;

[sig_long, sig_short] = tai.Willr(ClosePrice, HighPrice, LowPrice, nday, thred1, thred2, type);

if nargout == 0
    willr.willr = ind.willr(HighPrice, LowPrice, ClosePrice, nday);
    bars.plotind2(sig_long + sig_short, willr, true);
    title('willr rs');
end
end