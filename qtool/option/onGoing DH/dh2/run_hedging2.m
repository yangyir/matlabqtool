clear all; rehash;

h2 = Deltahedging2();


% h2.counter.login();
h2.init_real_account_setting()
h2.get_current_price();
h2.init_option_setting(0.05, 2.20, '2016-03-25', 0.25, 'call');
h2.update_portfolio();

h2.cal_delta(); %�ٰ�init_option_setting�е�past_delta��ֵΪ��ǰdelta��

h2.BS_option_price();
 

% pause(60)

%% ѭ�� 1

% TODO�� ��ʲô������ѭ�� �� ȡϵͳʱ�䣿
iter = 0;
while 1 && iter<200
    
h2.get_current_price();
%h1.current_underling_price = 2.43;
h2.cal_delta();



h2.openfire();
% TODO������µ����ɹ������кܸ��ӵĴ���

iter = iter +1;
iter
% pause(60);

% TODO: ����һ�½�����Ϣ
h2.update_portfolio;


% TODO����¼״̬���� ��ǰʱ�䣬S�۸�S��������������������fee������callPrice
%       ��¼״̬ �����

% TODO��ʵ���н���fee

end


%�˳���¼
h2.logout();


%% ѭ�� 2

% TODO�� ��ʲô������ѭ�� �� ȡϵͳʱ�䣿
%while 1
    
h2.get_current_price();
h2.cal_delta();



h2.openfire();
% TODO������µ����ɹ������кܸ��ӵĴ���


pause(120);

% TODO����¼״̬���� ��ǰʱ�䣬S�۸�S��������������������fee������callPrice
%       ��¼״̬ �����

% TODO��ʵ���н���fee

%end
%% ����ͷ���

% ���԰Ѽ�¼copy��excel����excel��������




