function [stockCode, startDate, expireDate] = fetch_optCode_by_feature(CP, strike, ExpireDate, xlsPath)
%�������
% OptHistoryInfo��Ȩ��Լ�б�
% CP Call Put
% strike ִ�м۸�
% ExpireDate�������� д�� '2016-09'(9�·ݵ���)
%�������
% stockCode��Լ����
% startDate��Լ����ʼ����
%Demo
% [stockCode, startDate, expireDate] = OptInfo.fetch_optCode_by_feature( 'call', 2.3, '2016-12')
% [stockCode, startDate, expireDate] = OptInfo.fetch_optCode_by_feature( 'call', 2.2, '2016-08')
% [stockCode, startDate, expireDate] = OptInfo.fetch_optCode_by_feature( 'put', 2.2, '2016-08')
%wuyunfeng 20170720 

%% ���ݽ��д���

persistent OPT_HISTORY_INFO;
persistent OPT_HISTTORY_CODES;
persistent OPT_HISTTORY_CPS;
persistent OPT_HISTTORY_STRIKES;
persistent OPT_HISTTORY_STARTDATES;
persistent OPT_HISTTORY_EXPIREDATES;
persistent OPT_HISTTORY_EXPIREDATESSTR;

if isempty(OPT_HISTORY_INFO)
    if ~exist('xlsPath', 'var')
        xlsPath = 'OptHistoryInfo.xlsx';
    end
    [~, ~, OPT_HISTORY_INFO] = xlsread(xlsPath);
    OPT_HISTTORY_CODES    = OPT_HISTORY_INFO(:, 1);
    OPT_HISTTORY_CPS      = OPT_HISTORY_INFO(:, 3);
    OPT_HISTTORY_STRIKES     = cell2mat(OPT_HISTORY_INFO(:, 4));
    OPT_HISTTORY_STARTDATES  = OPT_HISTORY_INFO(:, 6);
    OPT_HISTTORY_EXPIREDATESSTR = OPT_HISTORY_INFO(:, 7);
    OPT_HISTTORY_EXPIREDATES = year(OPT_HISTTORY_EXPIREDATESSTR) * 12 + month(OPT_HISTTORY_EXPIREDATESSTR);
end

stockCode = '';
startDate = '';


%% ��ȡ��Լ

% CP����
pred_call = ismember(CP, {'Call', 'call', 'c', 'C', '�Ϲ�'});
pred_put  = ismember(CP, {'Put' , 'put' , 'p', 'P', '�Ϲ�'});
assert(pred_call || pred_put)
if pred_call
    line_cp = strcmp('�Ϲ�', OPT_HISTTORY_CPS);
else
    line_cp = strcmp('�Ϲ�', OPT_HISTTORY_CPS);
end
OptHistoryCodes       = OPT_HISTTORY_CODES(line_cp);
OptHistoryStrikes     = OPT_HISTTORY_STRIKES(line_cp);
OptHistoryStartDates  = OPT_HISTTORY_STARTDATES(line_cp);
OptHistoryExpireDates = OPT_HISTTORY_EXPIREDATES(line_cp);
OptHistoryExpireDatesStr = OPT_HISTTORY_EXPIREDATESSTR(line_cp);

% Strike����
strikeLine = abs(OptHistoryStrikes - strike) < 1e-7;
if any(strikeLine)
    OptHistoryCodes    = OptHistoryCodes(strikeLine);
    OptHistoryStartDates  = OptHistoryStartDates(strikeLine);
    OptHistoryExpireDates = OptHistoryExpireDates(strikeLine);
    OptHistoryExpireDatesStr = OptHistoryExpireDatesStr(strikeLine);
else
    return;
end

% Expire����
dateVal = year(ExpireDate) * 12 + month(ExpireDate);
expireLine = OptHistoryExpireDates == dateVal;
if any(expireLine)
    stockCode = OptHistoryCodes{expireLine};
    startDate = OptHistoryStartDates{expireLine};
    expireDate = OptHistoryExpireDatesStr{expireLine};
else
    return;
end










end