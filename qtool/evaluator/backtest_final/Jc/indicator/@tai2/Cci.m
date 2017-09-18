function [ sig_rs ] = Cci( bar, tp_per, md_per, const, type)
% �ú������ CCI ��ǿ���ź��Լ� CCI ����ֵ
% CCI �̻��˹�Ʊ�Ƿ��г�����߳����������ڶ���ָ��
% ���� HighPrice,LowPrice,ClosePrice �ֱ��ǵ�����߼ۣ���ͼۣ����̼ۣ�
% ���� tp_per Ϊ tp �����ƶ�ƽ��ʱ������
% ���� md_per Ϊ md �����ƶ�ƽ��ʱ������
% ���� const  Ϊ����ϵ��
% ��� sig_rs Ϊָ���ǿ���źţ�Ϊ 1��-1���ֱ�Ϊ���룬��������
% ��� cci    Ϊָ�� cci ����ֵ

% ���������Ԥ����
if ~exist('tp_per', 'var') || isempty(tp_per), tp_per = 20; end
if ~exist('md_per', 'var') || isempty(md_per), md_per = 20; end
if ~exist('const', 'var') || isempty(const), const = 0.015; end
if ~exist('type', 'var') || isempty(type), type = 1; end

ClosePrice = bar.close;
HighPrice = bar.high;
LowPrice = bar.low;

sig_rs = tai.Cci(HighPrice, LowPrice, ClosePrice, tp_per, md_per, const, type);

if nargout == 0
    cci.cci = ind.cci(HighPrice, LowPrice, ClosePrice, tp_per, md_per, const);
    bar.plotind2(sig_rs, cci, true);
    title('cci rs');
end

end