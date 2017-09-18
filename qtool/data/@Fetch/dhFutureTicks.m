function [ ticks, Sflag ] = dhFutureTicks(code, tday, levels)
%DHFUTURETICKS ��DataHouseȡFuture Ticks���ݣ�ֻ��ȡһ��
% [ tks, Sflag ] = dhFutureTicks(code, tday, levels)
%     code:       ��ͬ 'IF0Y00', 'IFhot' , ֻ��ȡһ������֧������
%     tday:       ���ڣ������ı�������������ʽ 
%     levels:     1��5��Ĭ��1
% ====================================================================
% �̸գ�140611
% �̸գ�140725��tday�����ı�������������ʽ
% �̸գ�volume�ǹ�����amount��Ԫ��֮ǰ����



%% default values
if ~exist('code','var')
    disp('ȡTicks����ʧ�ܣ�û��code');
    Sflag = 0;
    return;
end

% ��cell��ʽ��code�ĳ�char
if isa(code, 'cell') 
    if length(code) > 1
        disp('���棺code��֧���������룬ֻȡ��һ��');
    end
    code = code{1};
end



if ~exist('levels', 'var') , levels = 1; end


%
if ~exist('tday', 'var')
    tday = datestr(today-7, 'yyyy-mm-dd');
    disp(['����������,����Ĭ��Ϊ' tday]);
end

% �Ѹ��ָ�ʽ��tday��ת�� yyyy-mm-dd (��Դ���ܵĸ�ʽ��
% if isa(tday, 'double') 
%     tday = datestr(tday, 'yyyy-mm-dd');
% elseif isa(tday, 'char')
%     tday = datestr( datenum(tday), 'yyyy-mm-dd');
% end

%% main
ticks = Ticks;

% ������
ticks.code = code;
ticks.levels = 0; %�����ٸ�

% datenum( �������� �� ��Ȼ��������������
% datestr( �ı����� �� ��Ȼ���ı���������
ticks.date = datenum(tday);
ticks.date2 = datestr(tday);

% �����Ҫ���
ticks.type = 'future'; 

% �Ӿ�Դȡ����
ticks.time = DH_Q_HF_Future(code,tday,'BargainTime');
if isempty(ticks.time) || sum(isnan(ticks.time)) == length(ticks.time) %��ֹ�����к�һ��nan
    Sflag = 0;
    disp('ȡTick����ʧ��');
    return;
end
% tks.time = tks.time + tks.date;

ticks.latest = length(ticks.time);

% ��������    
ticks.last    = DH_Q_HF_Future(code,tday,'ClosePrice');
ticks.amount  = DH_Q_HF_Future(code,tday,'AccuBargainSum');  % Ԫ
ticks.volume  = DH_Q_HF_Future(code,tday,'AccuBargainAmount'); % �ɡ���
% DH_Q_HF_Future(code,tday,'AccuBargainSum');
ticks.openInt = DH_Q_HF_Future(code,tday,'OpenInterest');


% ����
tmp = DH_Q_HF_Future(code,tday,'SettlementPrice');
ticks.settlement      = unique(  tmp(  ~isnan(tmp)  )  );
ticks.preSettlement   = unique( DH_Q_HF_Future(code,tday,'PreSettlementPrice'));
ticks.dayVolume   = ticks.volume(ticks.latest);
ticks.dayAmount   = ticks.amount(ticks.latest);
ticks.open        = ticks.last(   find(~isnan(ticks.last),1,'first')  );
ticks.close       = ticks.last(   find(~isnan(ticks.last),1,'last')  );
ticks.high        = nanmax(ticks.last);
ticks.low         = nanmin(ticks.last);


% bid��ask���۵�
switch levels
    case{ 1 }         
        ticks.bidP = DH_Q_HF_Future(code,tday,'Buy1Price');
        
        if isempty(ticks.bidP) || sum(isnan(ticks.bidP)) == length(ticks.bidP) 
            ticks.levels  = 0;
        else 
            ticks.bidV = DH_Q_HF_Future(code,tday,'Buy1Amount');
            ticks.askP = DH_Q_HF_Future(code,tday,'Sell1Price');
            ticks.askV = DH_Q_HF_Future(code,tday,'Sell1Amount');
            
            ticks.levels = 1;
        end
        
    case{ 5 }
        ticks.bidP = DH_Q_HF_Future(code,tday,{'Buy1Price','Buy2Price','Buy3Price','Buy4Price','Buy5Price'});
        ticks.askP = DH_Q_HF_Future(code,tday,{'Sell1Price','Sell2Price','Sell3Price','Sell4Price','Sell5Price'});
        ticks.bidV = DH_Q_HF_Future(code,tday,{'Buy1Amount','Buy2Amount','Buy3Amount','Buy4Amount','Buy5Amount'});
        ticks.askV = DH_Q_HF_Future(code,tday,{'Sell1Amount','Sell2Amount','Sell3Amount','Sell4Amount','Sell5Amount'});
        
        if isempty(ticks.bidP)
            ticks.levels = 0;
        end
end



%% ��ʾ�ɹ�
str = sprintf('��ȡ��%s��%s��level%d����.',ticks.code, ticks.date2, ticks.levels );
disp(str);



end

