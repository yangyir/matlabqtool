function [ ] = demo_test_v1(  )
%DEMO TEST
% �ɵ������ǣ�
% ��excel�г�ʼ������������Ȩ��Ϣ
% Ȼ�󣬽���һ��structure����payoff����ͼ
% ������Ȩ�ɱ����������ۼ۸�
% ---------------------------
% ���㣬20160126
% ���Ʒ壬fantuanxiaot��20160126
% ���㣬20160128���޸�drawpayoff ����������cost
% ����/���Ʒ壬20160128������table������ʹ��
% ���Ʒ壬20160229������OptPricer�Ļ�ȡ�ķ����������
% ���Ʒ�/���㣬20160316�����OptPricer/OptInfo ����
% ���㣬20160316�������趨ÿ����Ȩ������
% ���㣬20160316��������������

%% -------------------------------���һ��------------------------%%

clc
clear
close all
format compact
format short g

%% -------------------------------��ʼ��( ע���ǻ���optPricer )-----------------------------%%

%path = 'D:\intern\optionClass\@OptInfo\';       % ��������޸�
path = 'I:\new\intern\optionClass\';   % Mian Huang local path
fn = 'OptInfo.xlsx';                             % ��������޸�

%% --------------------------------��ȡ����---------------------------------------------%%

[ ~ , m2tkCallPricer , m2tkPutPricer ] = OptPricer.init_from_sse_excel( [ path , fn ] );
% ���ǻ�ȡ�õ�OptPricer������

%% �����ͼ

[ ~, m2tkCallinfo, m2tkPutinfo ] = OptInfo.init_from_sse_excel( [path, fn] );


%% -------------������Ȩ��� -------------------%%

sPricer = Structure;
sInfo   = Structure;
L = length( m2tkCallinfo.xProps );

% ȡ����T��ͬ�ĺ�Լ������ �Ƿ�ȡ��2ά�ģ�
k = 3;
for i = 1:L
    sPricer.optPricers(1,i) = m2tkCallPricer.data(k,i);
    sPricer.optPricers(2,i) = m2tkPutPricer.data(k,i);
    sInfo.optInfos( 1 , i ) = m2tkCallinfo.data( k , i );
    sInfo.optInfos( 2 , i ) = m2tkPutinfo.data( k , i );
end

%% ��structure sPricer �������Ȩ�۸�Ȼ������sInfo ��ͼ
% ��Ҫһ������ȷ��s.num λ��/ �޸�Ϊtabel���͸���
% ��鵱ǰ��
% S; 
% ��һ����call �����ڶ�����put ��

sInfo.num = zeros(2,L); 
% s.num(1,4:7)  = [-0,1,0,0];
% s.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];

RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});

t2{ {'2.05'}  , {'put'}}   = -1; % ֱ��������Ӧ����������
t2{ {'2.05'}  , {'call'}} = -1;    % '2' ����2.0����һ��

t2{ {'2.1'}  , {'call'}}   = 1; % ֱ��������Ӧ����������
t2{ {'1.8'}  , {'put'}} = 1;    % '2' ����2.0����һ��

% ���ڿ��Լ�����Ȩ��ϵĶ���
% ȡ������
% s.num(1,6) = 1;
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
sInfo.S     = 2.15;
sPricer.S   = sInfo.S;

% ���Զ�ÿһ����Ȩ�趨��ͬ�Ĳ�����
for i = 1:L
    sPricer.optPricers(1,i).sigma = 0.2;
    sPricer.optPricers(2,i).sigma = 0.4;
end
cost      = sPricer.calcPx;

ST = 1.6:0.05:2.8;
% s2.calcPayoff( ST );
sInfo.drawPayoff( ST , cost);


%% demo of two strategies
% 1, stock repair, long 1 ATM call sell 2 OTM call 
% plus one best C-P and a bear spread  
sInfo.S   = 2.1;
sPricer.S = sInfo.S;
sInfo.num = zeros(2,L); 
RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});
t2{ {'2'}  , {'call'}} = 1; % ֱ��������Ӧ����������
t2{ {'2.05'}  , {'call'}} = -2;    % '2' ����2.0����һ��

t2{ {'2.1'}  , {'call'}} = 1; % ֱ��������Ӧ����������
t2{ {'2.1'}  , {'put'}} = -1;    % '2' ����2.0����һ��

t2{ {'1.95'}  , {'call'}} = 2; % ֱ��������Ӧ����������
t2{ {'1.8'}  , {'call'}} = -2;    % '2' ����2.0����һ��
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
cost      = sPricer.calcPx;
ST = 1.6:0.05:2.6;
sInfo.drawPayoff( ST , cost);

% 2, sell 1 strip with low K then buy one call 
% plus one best C-P and a bear spread  
sInfo.S   = 2.1;
sPricer.S = sInfo.S;
sInfo.num = zeros(2,L); 

RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});


t2{ {'1.85'}  , {'call'}} = -1; % ֱ��������Ӧ����������
t2{ {'1.85'}  , {'put'}} = -1;    % '2' ����2.0����һ��

t2{ {'1.9'}  , {'call'}} = 1; % ֱ��������Ӧ����������

% ���ڿ��Լ�����Ȩ��ϵĶ���
% ȡ������
% s.num(1,6) = 1;
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
% ���Զ�ÿһ����Ȩ�趨��ͬ�Ĳ�����
for i = 1:L
    sPricer.optPricers(1,i).sigma = 0.2;
    sPricer.optPricers(2,i).sigma = 0.4;
end
cost  = sPricer.calcPx;

ST = 1.6:0.05:2.6;
% s2.calcPayoff( ST );
sInfo.drawPayoff( ST , cost);


%% -------------����50ETF��Ȩ��ϵ�����payoff---------------%%
% ��Ҫ����ST�ķֲ�
% ��������ST����

ST = 1.6:0.05:2.8;
% ���Խ�����������
payOff = sInfo.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '��Ȩ��ϵ�����payoffΪ = %.3f' , EF );
disp( str );


end

