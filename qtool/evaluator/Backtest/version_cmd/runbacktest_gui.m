global Path_Gildata;
if isempty(Path_Gildata)
    Path_Gildata = 'D:\MATLAB\R2011b\toolbox\gildata';
end
global Path_Gildata_Backtest;
% ����·������Path_Gildata_Backtest�����������Ϊ��ʼ·���������backtest·��·�������޸ġ�
% ��ֻ�轫ά������·�����ɡ�������·����Ϊ����backtest�ļ���·�����ɡ�
% �� ��backtest·��Ϊ�� C:\gildata\backtest    ����޸�Ϊ��
%   Path_Gildata_Backtest =  'C:\gildata\backtest';
Path_Gildata_Backtest = strcat(Path_Gildata,'\Backtest');
path_backtest_configure = strcat(Path_Gildata_Backtest,'\Configure\ConfigureBacktest.xlsx');

% configurefiletype Ϊ1ʱʹ��.xlsx��Ϊ����Դ��2ʹ��.mat��Ϊ����Դ��
configurefiletype = 1;

% ��ȡ��ʼ����
disp('���ڶ����ʼ���ã���ȴ���...');
Configure_Gildata_Backtest = readconfigure(path_backtest_configure,configurefiletype);

% ��ȡ��������
disp('���ڶ��������������ȴ���...');
Configure_Gildata_Backtest.StrategyExample = readstrategy(Configure_Gildata_Backtest.Path_Strategy_Configure,...
    Configure_Gildata_Backtest.configurefiletype);

Gildata_Backtest_Input2;

