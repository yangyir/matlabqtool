%% mex file generate
mex -g rh_counter_login.cpp
mex -g rh_counter_loadentrusts.cpp
mex -g rh_counter_loadtrades.cpp
mex -g rh_counter_getaccountinfo.cpp
mex -g rh_counter_getpositions.cpp
mex -g rh_counter_querysettleinfo.cpp
mex -g rh_counter_logout.cpp
mex -g rh_counter_qryaccount.cpp
mex -g rh_counter_mdlogin.cpp
mex -g rh_counter_mdlogout.cpp
mex -g rh_counter_withdrawoptentrust.cpp
mex -g rh_counter_queryoptentrust.cpp
mex -g rh_counter_placeoptentrust.cpp
mex -g rh_counter_getoptquote.cpp
mex -g rh_counter_faketest.cpp
%mex -g rh_counter_testmd.cpp

%% ��¼
% �ں���
%  yy02 ���� 123123
%  192.168.41.194 10001 ����
%                10006 ����
%  ʵ��brokerid=RohonReal
%  ģ����brokerid=RohonDemo
etf_front_addr = 'tcp://120.136.134.132:10001';
etf_broker = 'RohonDemo';
etf_investor = 'jxqhly01';
etf_pwd = '888888';
product_info = '';
authen_code = '';
counter_id = rh_counter_login(etf_front_addr, etf_broker, etf_investor, etf_pwd,product_info,authen_code);

%% rh_counter_loadtrades
%��ѯ�ɽ���Ϣ
[trades, ret] = ctp_counter_loadtrades(counter_id)


%% [trades, ret] = ctp_counter_loadtrades(counter_id)
%��ѯ����ί����Ϣ
[entrusts, ret] = rh_counter_loadentrusts(counter_id)


%% rh_counter_getaccountinfo
%qry account info
[account, ret] = rh_counter_getaccountinfo(counter_id);
account
if ~ret
    disp('��ѯ�ʽ�ʧ��');
end

%% ��ѯ�ֲ���Ϣ  ��Ȼ����bug �콭���ڽ����
[positions, ret] = rh_counter_getpositions(counter_id,'');
positions
if ~ret
    disp('��ѯ�ֲ�ʧ��');
end

%%
% �µ�
% direction : 1 = buy , 2 = sell
% offset : 1 = open, 2 = close;
entrust_id = 4; %ί�б�� ����ά��
asset_type = 1;
code = 'ni1810'
direction = 1;
offset = 1;
price = 102180;
amount = 1;

[ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
sysid


%% ��ѯί��
[dealinfo] = rh_counter_queryoptentrust(counter_id, entrust_id);
dealinfo


%% rh_counter_withdrawoptentrust
% ί�г���
[ret] = rh_counter_withdrawoptentrust(counter_id , entrust_id)

%% �ҵ���������
i  = 100 %���Դ���
while(i)
    i = i - 1;
    % �ҵ�
    % direction : 1 = buy , 2 = sell
    % offset : 1 = open, 2 = close;
    entrust_id = i; %ί�б�� ����ά��
    asset_type = 1;
    code = 'ni1810'
    if mod(i,2) == 0
        direction = 1;
        offset = 1;
        price = 102000;
    else
        direction = 2;
        offset = 1;
        price = 103000;
    end
    amount = 1;
    [ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
    pause(1)
    sysid
    % ί�г���
    [ret] = rh_counter_withdrawoptentrust(counter_id , entrust_id)
    pause(1)
    

end


%% �ǳ�
ret = rh_counter_logout(counter_id);




%% ����md

clear all; rehash;

front_addr_ = 'tcp://125.64.36.26:52213';
broker_id_ = '2001';
investor_id_ = '8880000052';
investor_password_ = '123456';

ret = rh_counter_mdlogin(front_addr_, broker_id_, investor_id_, investor_password_);


%% ��ȡ����
[mkt, level, update_time] = rh_counter_getoptquote('rb1810');



