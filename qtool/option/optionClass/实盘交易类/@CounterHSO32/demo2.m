function [  ] = demo2(  )
%DEMO2 �µ�����
%   �˴���ʾ��ϸ˵��

%%
% c.logout;
clear all; rehash
tf = timerfind; 
delete(tf)
pause(2);

%% ����counter
c = CounterHSO32.hequn2038_2034_opt;
c.login;
c.printInfo;


%% ����Ȩ

% �������е�quoteOpt������M2TK����
fn = 'C:\Users\Rick Zhu\Documents\Synology Cloud\intern\optionClass\OptInfo.xlsx'
% fn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
[q, m2c, m2p] =  QuoteOpt.init_from_sse_excel( fn );
stra.quote = q;
stra.m2tkCallQuote  = m2c;
stra.m2tkPutQuote   = m2p;


% 
S = 1.97;
K_put = 1.95;
K_call = 2;

iK     = m2c.getIdxByPropvalue_X( K_call );
iT      = 3;
call    = m2c.getByIndex(iK, iT);

iK      = m2p.getIdxByPropvalue_X( K_put);
put     = m2p.getByIndex(iK, iT);


%% ȡ�۸�

call.askP1 = 0.1234;



%% �
e = Entrust;
mktNo   = '1';
stkCode = num2str(call.code );
direc   = '1';
px      = call.askP1;
vo      = 1;
offset  = '1';
e.fillEntrust(mktNo, stkCode, direc, px, vo, offset);


%% �µ�
% ���⴦��һ��direction��kp�� HSO32���� '1' , '2'
d = e.get_CounterHSO32_direction;
kp = e.get_CounterHSO32_offset;

[errorCode,errorMsg,entrustNo] = c.optPlaceEntrust( ...
    e.marketNo, ...
    e.instrumentCode, ...
    d, ...
    kp, ...
    e.price, ...
    e.volume);

if errorCode == 0
    fprintf('[%d]ί�гɹ�{%s, %s, %d, %0.4f}', entrustNo, d, kp, e.volume, e.price);   
else
    disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
    return;
end


%% ��ѯ�ɽ�

[errorCode,errorMsg,packet]     = c.queryOptEntrusts( entrustNo);
if errorCode == 0
    PrintPacket2(packet);
end

pause(1);

%% ����������ѯ
[errorCode, errorMsg,cancelNo] = c.optEntrustCancel( entrustNo);

[errorCode,errorMsg,packet]     = c.queryOptEntrusts( entrustNo);
if errorCode == 0
    PrintPacket2(packet);
end


%% ETF:
%[errorCode,errorMsg,entrustNo]  = entrust(self, marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)
%[errorCode,errorMsg,packet]     = queryEntrusts(self, entrustNo);
%[errorCode,errorMsg,cancelNo]   = entrustCancel(self, entrustNo);
%[errorCode,errorMsg,packet]     = queryDeals(self, entrustNo);
c_etf = CounterHSO32.hequntest_2038_etf;
c_etf.login;
c_etf.printInfo;

e_etf = Entrust;
mktNo   = '1';
stkCode = '510050';
direc   = '1';
px      = 1.97;
vo      = 100;
offset  = '1';
e_etf.fillEntrust(mktNo, stkCode, direc, px, vo, offset);

[errorCode,errorMsg,entrustNo]  = c_etf.entrust(e_etf.marketNo,stkCode,direc, e_etf.price, e_etf.volume);

if errorCode == 0
    [errorCode,errorMsg,packet]     = c_etf.queryEntrusts(entrustNo);
    PrintPacket2(packet);
end
[errorCode,errorMsg,cancelNo]   = c_etf.entrustCancel(entrustNo);

%% FUT:
%[errorCode,errorMsg,entrustNo]  = futPlaceEntrust(self, marketNo,stockCode,entrustDirection,futuresDirection,entrustPrice,entrustAmount)
%[errorCode,errorMsg,packet]     = queryFutEntrusts(self, entrustNo);
%[errorCode,errorMsg,cancelNo]   = futEntrustCancel(self, entrustNo);
%[errorCode,errorMsg,packet]     = queryFutDeals(self, entrustNo);
c_fut = CounterHSO32.hequntest_2038_fut;
c_fut.login;
c_fut.printInfo;

[errorCode, errorMsg, packet] = c_fut.queryAccount;
PrintPacket2(packet);

e_fut = Entrust;
mktNo   = '7';
stkCode = 'IF1609';
direc   = '1';
px      = 2000;
vo      = 1;
offset  = '1';
e_fut.fillEntrust(mktNo, stkCode, direc, px, vo, offset);

[errorCode,errorMsg,entrustNo]  = c_fut.futPlaceEntrust(e_fut.marketNo,e_fut.instrumentCode,direc, offset,e_fut.price,e_fut.volume);

end

