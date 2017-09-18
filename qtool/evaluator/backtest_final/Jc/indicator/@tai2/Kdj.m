function [sig_long, sig_short, sig_rs] = Kdj(bar, thred1, thred2, nday, m, l, type)
%����kdjֵ�Լ���Ӧ�Ľ����ź�(-1,0,1)
%���� ClosePrice,HighPrice,Lowprice,n,type���У�n��ʾ���ڵĳ���
%type  ��ʾma������̵�ϵ��ѡ��ʽ 
%type 1 [2/3 1/3] type 2 [(n-1)/n 1/n]
%��� pos �����źţ�kdj �����kdjֵ
%   Yan Zhang   version 1.0 2013/3/12 
%
%   sig_long  ��K�ϴ�30ʱ�����룬�ź�Ϊ1 ���ź�Ϊ1��K��70���£�K��D�������棬�źŸ�Ϊ-1 
%   sig_short ��K�´�70ʱ���������ź�Ϊ-1 ���ź�Ϊ-1��K��30���ϣ�K��D�������棬�źŸ�Ϊ-1 
%   sig_rs   K<30���������ź�Ϊ1��K��70�������ź�Ϊ-1
%   Yan Zhang   version 1.1 2013/3/12

if ~exist('nday', 'var') || isempty(nday), nday = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[sig_long, sig_short, sig_rs] = tai.Kdj(bar.close, bar.high, bar.low, thred1, thred2, nday, m, l, type);

if nargout == 0
    [kdj.k, kdj.d, kdj.j] = ind.kdj(bar.close, bar.high, bar.low, thred1, thred2, nday, m, l);
    bar.plotind2(sig_long + sig_short, kdj, true);
    title('kdj long and short');
    bar.plotind2(sig_rs, kdj, true);
    title('kdj rs');
end
end