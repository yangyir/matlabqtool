clear all; rehash;

h1 = Deltahedging1();


% h1.init_trading_setting();
h1.init_real_account_setting();
h1.get_current_price();
h1.init_option_setting();
h1.update_portfolio();

h1.cal_delta(); %�ٰ�init_option_setting�е�past_delta��ֵΪ��ǰdelta��


 

% pause(60)

%% ѭ�� 1

% TODO�� ��ʲô������ѭ�� �� ȡϵͳʱ�䣿
iter = 0;
while 1 && iter<200
    
h1.get_current_price();
%h1.current_underling_price = 2.43;
h1.cal_delta();



h1.openfire();
% TODO������µ����ɹ������кܸ��ӵĴ���

iter = iter +1;
iter
% pause(60);

% TODO: ����һ�½�����Ϣ
h1.update_portfolio;


% TODO����¼״̬���� ��ǰʱ�䣬S�۸�S��������������������fee������callPrice
%       ��¼״̬ �����

% TODO��ʵ���н���fee

end


%�˳���¼
h1.logout();


%% ѭ�� 2

% TODO�� ��ʲô������ѭ�� �� ȡϵͳʱ�䣿
%while 1
    
h1.get_current_price();
h1.cal_delta();



h1.openfire();
% TODO������µ����ɹ������кܸ��ӵĴ���


pause(120);

% TODO����¼״̬���� ��ǰʱ�䣬S�۸�S��������������������fee������callPrice
%       ��¼״̬ �����

% TODO��ʵ���н���fee

%end
%% ����ͷ���

% ���԰Ѽ�¼copy��excel����excel��������




