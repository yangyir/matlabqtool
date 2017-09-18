% clear;
% clc;
%%
%         cost:        �����׳ɱ���Ϊ�ɱ�ռ���ױ�Ľ��ı���������Ӧ����Ӷ��
%                      Ҳ���ʵ��Ӵ��Է�Ӧ����ɱ���
%         leverage��   �ܸ��ʣ�һ��Ϊһ����[1,8]֮�����ֵ��Ϊ���׽������ڼƻ����
%                      �ķŴ��ʡ�
%         lag��        �ź��ӳٵ�λ��Ĭ��ֵΪ1,Ϊһ����������lag=N�����²����Ľ����źŽ���N��
%                      ʱ����Ƭ֮��ɽ����ź��ӳٵ�ȷ����Ҫ����ʵ�ʵĽ���ʱ����ȷ����
%         orderStyle:  �µ����Ĭ��ֵΪ0.
%                      orderStyle = 0������signal������Ľ������µ���
%                      orderStyle = 1, ����signal�жϽ��׷���ÿ��ֻ��1�֡�
%         initValue��  ��ʼ�˻���Ӧȫ��Ϊ�ֽ�
%         multiplier�� ��Լ������
%         marginRate�� �ڻ��������涨����ͱ�֤�������
%         riskfreebench�� 
%                      �껯�޷������ʡ�
%         varmethod��  ������ռ�ֵ�ķ�����Ŀǰֻ�ṩһ�ַ�����Ĭ��ֵΪ1��
%         vara��       ������ʧ�������ռ�ֵ�������ʡ�1-vara�Ƿ��ռ�ֵ������ˮƽ��
%                      Ĭ��ֵ0.05.
%         riskIndex��  �������ϵ���Ŀ��أ�Ĭ��ֵΪ1.
%                      riskIndex = 1���������ϵ����
%                      riskIndex = 0�����������ϵ����
%    
% ���������˵�����ò�����
configure.cost = 0.0003;
configure.leverage = 3;
configure.lag = 1;
configure.initValue = 1e5;
configure.multiplier = 300;
configure.marginRate = 0.12;
configure.riskfreebench = 0.03;
configure.varmethod = 1;
configure.vara = 0.05;
configure.riskIndex = 1;
configure.orderStyle = 1;
signal = importdata('signal.mat');
bars = importdata('barSample.mat');

%%
result = backtestF(signal,bars, configure);