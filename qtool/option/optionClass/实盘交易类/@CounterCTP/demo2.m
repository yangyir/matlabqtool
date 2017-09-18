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
fn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
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



end

