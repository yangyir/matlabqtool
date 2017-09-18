function  [sig_rs] = Bias(bar, nDay, type)
% bias ������
% ֻ���ǿ���ź�
% 2013/3/21 daniel

% ���㹫ʽ
% Yֵ�����������мۣ�N�����ƶ�ƽ�����мۣ�/N�����ƶ�ƽ�����мۡ�100��
% ���У�N��Ϊ�����������ɰ��Լ�ѡ���ƶ�ƽ��������������һ��ֶ�Ϊ6�գ�12�գ�24��
% ��72�գ���ɰ�10�գ�30�գ�75���趨��

% BIASָ���ȱ���������źŹ���Ƶ�������Ҫ�����ָ��(KDJ)��������ָ�꣨BOLL������ʹ�á�
% �����ʵ���ֵ�Ĵ�С����ֱ�������о��ɼ۵ĳ����������ж�������Ʊ��ʱ����
% ����ѡ�ù��������ڲ����Ĳ�ͬ�������������б�׼Ҳ����֮�仯��
% �����µķ����������ơ���5�պ�10�չ�����Ϊ�������巽�����£�
% 1��һ����ԣ��������г��ϣ��ɼ۵�5�չ����ʴﵽ��5���ϣ���ʾ�ɼ۳���������֣�
%    ���Կ��ǿ�ʼ�����Ʊ�������ɼ۵�5�չ����ʴﵽ5���ϣ���ʾ�ɼ۳���������֣�
%    ���Կ���������Ʊ��
% 2����ǿ���г��ϣ��ɼ۵�5�չ����ʴﵽ��10���ϣ���ʾ�ɼ۳���������֣�Ϊ����������᣻
%    ���ɼ۵�5�չ����ʴﵽ10���ϣ���ʾ�ɼ۳���������֣�Ϊ����������Ʊ�Ļ��ᡣ

%% Ԥ������bias����
close = bar.close;
if ~exist('nDay', 'var') || isempty(nDay), nDay = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% �ź�
sig_rs = tai.Bias(close, nDay, type);

if nargout == 0
    bia.bias = ind.bias(close, nDay);
    bar.plotind2(sig_rs, bia, true);
    title('bias rs');
end

end %EOF
