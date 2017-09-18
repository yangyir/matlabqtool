function  [sig_long, sig_short, sig_rs] = Trix (close, nDay, mDay,type)
% Trix ����ָ��ƽ��
% sig_long: ������룬û������ƽ�֣� sig_short������������û������ƽ�֣�
% ���Բ��䶥����͵ױ���ķ�ת����
% 2013/3/21 daniel

% TRIX�߻����÷�
% TRIXָ���������г���ָ�꣬�������ŵ���ǿ��Թ��˶��ڲ����ĸ��ţ��Ա���Ƶ������
% ��������ʧ�����ʧ�����TRIXָ�����ʺ��ڶ�������г������Ƶ����С�
% �ڹ��������TRIXָ���������ߣ�һ����ΪTRIX�ߣ���һ����ΪTRMA�ߡ�
% TRIXָ���һ�����б�׼��Ҫ������TRIX�ߺ�TRMA�ߵĽ�������Ŀ����ϡ�
% ����������������£�
% 1����TRIX��һ����������ͻ��TRMA�ߣ��γɡ���桱ʱ��Ԥʾ�Źɼۿ�ʼ����ǿ�������׶Σ�
%    Ͷ����Ӧ��ʱ�����Ʊ��
% 2����TRIX������ͻ��TRMA�ߺ�TRIX�ߺ�TRMA��ͬʱ�����˶�ʱ��Ԥʾ�Źɼ�ǿ�����ɣ�
%    Ͷ����Ӧ����ֹɴ��ǡ�
% 3����TRIX���ڸ�λ����ƽ���ͷ����ʱ������Ԥʾ�Źɼ�ǿ����������������
%    Ͷ����Ӧ����ע��ɼ۵����ƣ�һ��K��ͼ�ϵĹɼ۳��ִ������Ͷ����Ӧ��ʱ������Ʊ��
% 4����TRIX���ڸ�λ����ͻ��TRMA�ߣ��γɡ����桱ʱ��Ԥʾ�Źɼ�ǿ�����������Ѿ�������
%    Ͷ����Ӧ����������¹�Ʊ����ʱ�볡������
% 5����TRIX������ͻ��TRMA�ߺ�TRIX�ߺ�TRMA��ͬʱ�����˶�ʱ��
%    Ԥʾ�Źɼ������������ɣ�Ͷ����Ӧ����ֱҹ�����
% 6����TRIX����TRMA�·������˶��ܳ�һ��ʱ��󣬲��ҹɼ��Ѿ��нϴ�ĵ���ʱ��
%    ���TRIX���ڵײ�����ƽ�����Ϲ�ͷ����ʱ��һ���ɼ��ڴ�ĳɽ������ƶ�����������ʱ��
%    Ͷ���߿��Լ�ʱ���������߽��֡�
% 7����TRIX���ٴ�����ͻ��TRMA��ʱ��Ԥʾ�Źɼ۽���ʰ���ƣ�Ͷ���߿ɼ�ʱ���룬�ֹɴ��ǡ� 
% 8��TRIXָ�겻�����ڶԹɼ۵�������������С�

%% ����Ԥ�����tr trma ����

%if ~exist('nday', 'var') || isempty(nDay), nDay = 12; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 12; end% modified by Wu Zehui
if ~exist('mDay', 'var') || isempty(mDay), mDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end


[nPeriod, nAsset] = size(close);
[trix.tr, trix.trma] = ind.trix (close, nDay, mDay);
trix.trchg = (trix.tr(2:end,:)./trix.tr(1:end-1,:) -1)*100;
if type==1
%% �����ź�
sig_long = zeros(nPeriod, nAsset);
sig_long(logical(crossOver(trix.tr,trix.trma, 1)))=1;

sig_short = zeros(nPeriod, nAsset);
sig_short(logical(crossOver(trix.trma, trix.tr, 1)))=-1;

%% ǿ���ź�
sig_rs  = zeros(nPeriod, nAsset);
sig_rs(trix.tr >  trix.trma) =  1;
sig_rs(trix.tr <= trix.trma) = -1;
else
  ;
end
end


