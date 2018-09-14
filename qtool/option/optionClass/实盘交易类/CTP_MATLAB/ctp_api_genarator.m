clear all; rehash;

%% mex file generate
mex -g ctpcounterlogin.cpp
mex -g ctpcounter_getaccountinfo.cpp
mex -g ctpcounter_getpositions.cpp
mex -g placeoptentrust.cpp
mex -g queryoptentrust.cpp
mex -g ctpcounterlogout.cpp
%mex -g rh_counter_testmd.cpp

%% test ronhon api
% �ں���
%  yy02 ���� 123123
% 192.168.41.194 10001 ����
%                  10006 ����
% ʵ��brokerid=RohonReal
% ģ����brokerid=RohonDemo

% rh
etf_front_addr = 'tcp://192.168.41.194:10001';
etf_broker = 'RohonDemo';
etf_investor = 'yy02';
etf_pwd = '123123';
product_info = '';
authen_code = '';
%% ��ʼ��Counter
front_addr = 'tcp://125.64.36.26:52205';
broker = '2001';
investor = '8880000052';
pwd_ = '123456';


etf_front_addr = 'tcp://125.64.36.26:51205';
etf_broker = '2001';
etf_investor = '0000001052';
etf_pwd = '123456';

[counter_id, ret] = counterlogin(etf_front_addr, etf_broker, etf_investor, etf_pwd);
ret

%% �˻���ѯ
[account, ret] = ctpcounter_getaccountinfo(opt_counter_id);

if ~ret
    disp('��ѯ�ʽ�ʧ��');
end

%% �ֲֲ�ѯ
[positions, ret] = ctpcounter_getpositions(opt_counter_id, '');

if ~ret
    disp('��ѯ�ֲ�ʧ��');
end

%% �µ�����
% direction : 1 = buy , 2 = sell
% offset : 1 = open, 2 = close;
entrust_id = 2;
asset_type = 1;
code = '11001205'
direction = 1;
offset = 1;
price = 0.1103;
amount = 1;
%% �µ�
[ret, sysid] = placeoptentrust(opt_counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
sysid

pause(10);
%% ��ѯ
[dealinfo] = queryoptentrust(opt_counter_id, entrust_id);
dealinfo

loop = 10;
while ((dealinfo(1) + dealinfo(4)) < amount)
    [dealinfo] = queryoptentrust(opt_counter_id, entrust_id);
    dealinfo
    pause(5);
    loop = loop - 1;
    if loop < 1
        break;
    end
end

%% ����
[ret] = withdrawoptentrust(opt_counter_id, entrust_id);
ret

pause(10);
[dealinfo] = queryoptentrust(opt_counter_id, entrust_id);
dealinfo

%% �ǳ�

ret = counterlogout(counter_id);
ret

ret = counterlogout(opt_counter_id);
ret

% ctpcounterlogout(counter_id);


