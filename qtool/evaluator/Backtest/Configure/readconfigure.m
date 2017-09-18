%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڶ�ȡPath·���������ļ��еĳ�ʼ���á�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output  = readconfigure(path_backtest_configure,type)
% �������������2������Ĭ�϶�ȡexcel����
if nargin <2
    type = 1;
end
global Path_Gildata_Backtest;
if exist(path_backtest_configure,'file') && type == 1
    % ��ȡ��������
    [~,~,configure_data] = xlsread(path_backtest_configure,'Layout');
    % ͼ���������Ļ��λ��
    output.Figure_Position  = [str2double(configure_data{1,2}),str2double(configure_data{2,2}),str2double(configure_data{3,2}),str2double(configure_data{4,2})];

    %  ��ȡ����ָ������
    [~,~,configure_data] = xlsread(path_backtest_configure,'RiskIndex');
    
    % ҵ����׼
    output.benchmark = configure_data{1,2};
    % �г���׼
    output.marketbench = configure_data{2,2};
    % �޷������ʻ�׼
    output.riskfreebench = configure_data{3,2};
    % VaR����������a
    output.vara = configure_data{4,2};
    % ����VaR��ʹ�õķ�����Ŀǰֻ��ӷ���Э�����
    output.varmethod = configure_data{5,2};
  
    
    % ��ȡ��������
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Input');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Main');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Equity');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'BuySellPoint');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'StatisticalIndex');
else
    path_backtest_configure = strrep(path_backtest_configure,'.xlsx','.mat');
    load(path_backtest_configure); 
    output.Figure_Position =Figure_Position;
    output.benchmark = benchmark;
    output.marketbench = marketbench ;
    output.riskfreebench = riskfreebench;
    output.vara = vara;
    output.varmethod = varmethod;
end
% downloadmark Ϊ0������ʵʱ���ط�ʽ�������ݣ�downloadmarkΪ1ʱ�����ö�Cache��ʽ���ѻ�չ��ģʽ��
output.downloadmark = 0;

output.path_backtest_configure = path_backtest_configure;
% Cache·��
output.Path_Backtest_Cache = strcat(Path_Gildata_Backtest,'\Cache\');
% ��������·��
output.Path_Search_Strategy = strcat(Path_Gildata_Backtest,'\Strategy\');
% ��������·��
output.Path_Strategy_Configure = strcat(Path_Gildata_Backtest,'\Configure\strategy.xlsx');

output.configurefiletype = type;
% ���reportĬ��·��
output.outfile = 'C:\reports.xlsx report1';

end
