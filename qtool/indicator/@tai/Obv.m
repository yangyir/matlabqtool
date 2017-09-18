function [ sig_rs] = Obv( ClosePrice, Volume,type)
% On-Balance Volume 
% OBV ��������ָ��
% ���� �����ݡ� ���̼��Լ���������
% ��� sig_rs Ϊ���׵�ǿ���źţ�
% ��� obv Ϊָ�����ֵ��


%% ����Ԥ�������ʼ��
[nperiod, nasset]  =  size(ClosePrice);
% ������������
long  = 20;
short = 5;
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���� obv �Լ���Ӧ���źţ�
 obvVal  = ind.obv( ClosePrice, Volume );
% em_obv  =  tai.Ma( obvVal );          % obv �ƶ�ƽ��
% em_sl   =  tai.Ma( ClosePrice, long );  % close �ĳ����ƶ�ƽ��
% em_ss   =  tai.Ma( ClosePrice, short);  % close �Ķ����ƶ�ƽ��

em_obv = ind.ma( obvVal ); % obv �ƶ�ƽ��
em_sl = ind.ma( ClosePrice, long ); % close �ĳ����ƶ�ƽ��
em_ss = ind.ma( ClosePrice, short );% close �Ķ����ƶ�ƽ��

macd_obv  =  macd( obvVal );          % obv �� macd ��ֵ
sp_obv  =  obvVal - em_obv;           % obv �Լ��ƶ�ƽ���� spread
sp_st   =  em_ss - em_sl;          % ���̼۳����ƶ�ƽ���� spread
signal  =  zeros( nperiod, nasset);
% ǿ���źŵĽ��׹���

if type==1
signal( macd_obv > 0 & sp_obv > 0)  =  -1;  % ���� obv ���ϴ�Խ����ʾ����������
signal( macd_obv < 0 & sp_obv > 0)  =   1;  % ���� obv ���´�Խ����ʾ���������룻
signal( sp_obv >0 & sp_st <0)  =  1;   % �������󣬼۸�����½����Ƶ�ʱ�����룻
signal( sp_obv <0 & sp_st >0)  = -1;   % ������С���۸�����������Ƶ�ʱ��������
else
;
end
sig_rs  =  signal;
end

