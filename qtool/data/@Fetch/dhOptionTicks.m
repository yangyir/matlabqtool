function [ ticks, Sflag ] = dhOptionTicks(code, tday, levels)
%DHSTOCKTICKS ��DataHouseȡOption Ticks���ݣ�ֻ��ȡһ��
% [ ticks, Sflag ] = dhOptionTicks(code, tday, levels)
%     code:     ��Ҫ�� 8.2 ��ʽ����10000602.SH
%     tday:     ���ڣ���Դ�ֿɽ������ֻ��ı���Ĭ��today-7
%     levels:   1��5��Ĭ��1
%
% eg. c = Fetch.dhOptionTicks('10000602.SH','2016-05-13')
% ======================================================================
% �̸գ�161227��DH�����⣬ֻ��20160728֮ǰ������


%% default values
if ~exist('code','var')
    disp('ȡTicks����ʧ�ܣ�û��code');
    Sflag = 0;
    return;
end

if ~exist('levels', 'var') , levels = 1; end

if ~exist('tday', 'var')
    tday = datestr(today-7, 'yyyy-mm-dd');
    disp(['����������,����Ĭ��Ϊ' tday]);
end


%% main
ticks = Ticks;

% ������
ticks.code = code;
ticks.levels = 0; %�����ٸ�

% �Զ�ʶ���ı���ʽ�����ָ�ʽ������
% datenum( �������� �� ��Ȼ��������������
% datestr( �ı����� �� ��Ȼ���ı���������
ticks.date = datenum(tday);
ticks.date2 = datestr(tday);

% �����Ҫ���
ticks.type = 'option'; 


% �Ӿ�Դȡ���ݣ���Դ���Խ������ֺ��ı���ʱ��
ticks.time = DH_Q_HF_Option('10000602.SH',tday,'BargainTime');
if isempty(ticks.time) || sum(isnan(ticks.time)) == length(ticks.time) %��ֹ�����к�һ��nan
    Sflag = 0;
    disp('ȡTick����ʧ��');
    return;
end

ticks.latest = length(ticks.time);


% ����    
ticks.last = DH_Q_HF_Option(code,tday,'ClosePrice');
ticks.amount = DH_Q_HF_Option(code,tday,'AccuBargainAmount');
ticks.volume = DH_Q_HF_Option(code,tday,'AccuBargainSum');

% ����000300.SH �� 600000.SH������nan
% turnover = DH_Q_HF_Option(code,tday,'AccuTurnoverDeals');


% ����
ticks.preSettlement = unique( DH_Q_HF_Option(code,tday,'PreSettlementPrice'));
ticks.dayVolume   = ticks.volume(ticks.latest);
ticks.dayAmount   = ticks.amount(ticks.latest);
ticks.open    = ticks.last(   find(~isnan(ticks.last),1,'first')  );
ticks.close   = ticks.last(   find(~isnan(ticks.last),1,'last')  );
ticks.high    = nanmax(ticks.last);
ticks.low     = nanmin(ticks.last);


switch levels
    case{ 1 }         
        ticks.bidP = DH_Q_HF_Option(code,tday,'Buy1Price');
        
        if isempty(ticks.bidP) || sum(isnan(ticks.bidP)) == length(ticks.bidP) 
            ticks.levels  = 0;
        else 
            ticks.bidV = DH_Q_HF_Option(code,tday,'Buy1Amount');
            ticks.askP = DH_Q_HF_Option(code,tday,'Sell1Price');
            ticks.askV = DH_Q_HF_Option(code,tday,'Sell1Amount');
            
            ticks.levels = 1;
        end
        
    case{ 5 }
        ticks.bidP = DH_Q_HF_Option(code,tday,{'Buy1Price','Buy2Price','Buy3Price','Buy4Price','Buy5Price'});
        ticks.askP = DH_Q_HF_Option(code,tday,{'Sell1Price','Sell2Price','Sell3Price','Sell4Price','Sell5Price'});
        ticks.bidV = DH_Q_HF_Option(code,tday,{'Buy1Amount','Buy2Amount','Buy3Amount','Buy4Amount','Buy5Amount'});
        ticks.askV = DH_Q_HF_Option(code,tday,{'Sell1Amount','Sell2Amount','Sell3Amount','Sell4Amount','Sell5Amount'});
        
        if isempty(ticks.bidP)
            ticks.levels = 0;
        end
end



%% ��ʾ�ɹ�
str = sprintf('��ȡ��%s��%s��level%d����.',ticks.code, ticks.date2, ticks.levels );
disp(str);


end

