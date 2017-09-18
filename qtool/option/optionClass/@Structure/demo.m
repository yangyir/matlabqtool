function [ ] = demo(  )
%DEMO 
% �ɵ������ǣ�
% ��excel�г�ʼ������������Ȩ��Ϣ( OptInfo )
% DEMO�Ŀ���ǽ�����Structure��optInfos�ϵ�
% Ȼ�󣬽���һ��structure����payoff����ͼ
% ---------------------------
% �̸գ�20160124

%% -------------------------------���һ��------------------------%%

clc
close all
format compact
format short g

%% -------------------------------��ʼ��-----------------------------%%

% �����ֵ��OptInfo��ֵ
path = 'D:\intern\optionClass\@OptInfo\';       % ��������޸�
%path = 'I:\new\intern\optionClass\@OptInfo\';  % Mian Huang local path
fn = 'OptInfo.xlsx';                           % ��������޸�
[ ~, m2tkCallinfo, m2tkPutinfo] = OptInfo.init_from_sse_excel( [path, fn] );

%% -------------������Ȩ��� -------------------%%

sStructure = Structure;
L = length(m2tkCallinfo.xProps);

for i = 1:L
    sStructure.optInfos(1,i) = m2tkCallinfo.data(1,i);
    sStructure.optInfos(2,i) = m2tkPutinfo.data(1,i);
end

sStructure.num = zeros(2,L);
sStructure.num(1,4:7)  = [-1,2,0,-4];
sStructure.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];
% ���õ��ڵ�ST��ֵ
ST = 2.5;
sStructure.calcPayoff( ST );
sStructure.drawPayoff;

%% ---------------����50ETF����payoff---------------------------%%

% ��������ST����
ST = 1.6:0.05:2.8;
% ���Խ�����������
payOff = sStructure.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '��Ȩ��ϵ�����payoffΪ = %.3f' , EF );
disp( str );


end

