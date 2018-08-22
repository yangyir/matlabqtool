clear all; rehash;

% if not(libisloaded('CTP_Counter'))
%     [notfound, warnings] = loadlibrary('CTP_Counter', 'ctp_counter_export_wrapper.h');
%     notfound
%     warnings
% end
%% ��ʼ��Counter
front_addr = 'tcp://125.64.36.26:52205';
broker = '2001';
investor = '8880000052';
pwd_ = '123456';


etf_front_addr = 'tcp://180.168.146.187:10000';
etf_broker = '9999';
etf_investor = '121631';
etf_pwd = 'attention3!';
product_info = '';
authen_code = '';
[counter_id, ret] = counterlogin(etf_front_addr, etf_broker, etf_investor, etf_pwd,product_info,authen_code);
ret
% counter_id = ctpcounterlogin(etf_front_addr, etf_broker, etf_investor, etf_pwd);
[opt_counter_id, ret] = counterlogin(front_addr, broker, investor, pwd_);
ret
pause(10);



%% �˻���ѯ
[account, ret] = ctpcounter_getaccountinfo(counter_id);

if ~ret
    disp('��ѯ�ʽ�ʧ��');
end

%% �ֲֲ�ѯ
[positions, ret] = ctpcounter_getpositions(counter_id, '');

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
[ret, sysid] = placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
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


