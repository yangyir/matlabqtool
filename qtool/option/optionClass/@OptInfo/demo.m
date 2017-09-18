function [ ] = demo(  )
%DEMO 
% �ɵ������ǣ�
% ��excel�г�ʼ������������Ȩ��Ϣ
% Ȼ�󣬽���һ��structure����payoff����ͼ
% ---------------------------
% �̸գ�20160124

%% -------------------------------���һ��------------------------%%
% clc; clear all; rehash;
% close all

format compact

%% -------------------------------��ʼ��-----------------------------%%

path = 'T:\intern\optionClass\ @OptInfo\';       % ��������޸�
fn = 'OptInfo.xlsx';                            % ��������޸�
[ ~, m2tkCallinfo, m2tkPutinfo ] = OptInfo.init_from_sse_excel( [path, fn] );

%% -------------������Ȩ��� -------------------%%

s = Structure;
L = length(m2tkCallinfo.xProps);

% ȡ����T��ͬ�ĺ�Լ������ �Ƿ�ȡ��2ά��

for i = 1:L
    s.optInfos(1,i) = m2tkCallinfo.data(1,i);
    s.optInfos(2,i) = m2tkPutinfo.data(1,i);
end

s.num = zeros(2,L);
s.num(1,4:7)  = [-1,2,0,-4];
s.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];
ST = 2.5;
s.calcPayoff( ST );
s.drawPayoff;

%% ---------------����50ETF����payoff---------------------------%%

% ��������ST����
ST = 1.6:0.05:2.8;
% ���Խ�����������
payOff = s.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '��Ȩ��ϵ�����payoffΪ = %.3f' , EF );
disp( str );

end

