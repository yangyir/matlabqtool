function [ sig_rs] = Cci( HighPrice, LowPrice, ClosePrice,tp_per,md_per,const,type)
%% �ú������ CCI ��ǿ���ź��Լ� CCI ����ֵ
% CCI �̻��˹�Ʊ�Ƿ��г�����߳����������ڶ���ָ��
% ���� HighPrice,LowPrice,ClosePrice �ֱ��ǵ�����߼ۣ���ͼۣ����̼ۣ�
% ���� tp_per Ϊ tp �����ƶ�ƽ��ʱ������
% ���� md_per Ϊ md �����ƶ�ƽ��ʱ������
% ���� const  Ϊ����ϵ��
% ��� sig_rs Ϊָ���ǿ���źţ�Ϊ 1��-1���ֱ�Ϊ���룬��������
% ��� cci    Ϊָ�� cci ����ֵ

%% ���������Ԥ����

if ~exist('tp_per', 'var') || isempty(tp_per), tp_per = 20; end
if ~exist('md_per', 'var') || isempty(md_per), md_per = 20; end
if ~exist('const', 'var') || isempty(const), const = 0.015; end
if ~exist('type', 'var') || isempty(type), type = 1; end
nasset = size(ClosePrice,2);
nperiod = size(ClosePrice,1);
sig_rs= zeros(nperiod,nasset);


%% ���� CCI �Լ���Ӧ��ǿ���ź� sig_rs
[ cciVal] = ind.cci( HighPrice, LowPrice, ClosePrice,tp_per,md_per,const );
if type==1
    sig_rs(cciVal>100)  = -1;
    sig_rs(cciVal<-100)  = 1;
else
    sig_rs(cciVal>100)  = -1;
    sig_rs(cciVal<-100)  = 1;
end

end