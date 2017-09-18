% ��Rkdj��MACD��ͳ��
% luhuaibao, 2013.11.4


%% ���ݴ���
clc
clear
close all

%% ���ع�̬����
load('dataIF.mat');
%% ����Ŀ����

load('potenPL.mat');
proIF(isnan(proIF)) = 0;
losIF(isnan(losIF)) = 0;
proIF = proIF + losIF;


 
bars = dataIF ; 
% ��������
len_KDJ    = 14 ;
N1         = 13 ;
N2         = 8 ;
N3         = 3 ;
N4         = 3 ;
N5         = 2 ; 

[ vRsis ]       = ind.rsiMC(  bars  ,  N1 )  ;
vhs             = hhigh( vRsis,  N2 )  ;
vls             = llow( vRsis,  N2 )  ;
[vks,vds,~]       = ind.kdjMC( vRsis, vhs, vls,  len_KDJ,  N3,  N4, N5 ) ;

upLine = 75 ; 
dnLine = 25 ; 

cond1    =   crossOver( vks,upLine*ones(length(vks),1));
cond2    =   crossUnder(vks,upLine*ones(length(vks),1));
cond3    =   crossOver( vks,dnLine*ones(length(vks),1));
cond4    =   crossUnder(vks,dnLine*ones(length(vks),1));
%% ����macd
[dif, dea, vmacd]           = ind.macd( dataIF.close,12,26,9 ) ;
cond5 = dea > 0 ;
cond6 = dea < 0 ;

tag1 = zeros(length(vks),1) ; 
tag2 = zeros(length(vks),1) ; 
tag3 = zeros(length(vks),1) ; 
tag4 = zeros(length(vks),1) ; 
tag5 = zeros(length(vks),1) ; 
tag6 = zeros(length(vks),1) ; 

tag1(cond1) = 1 ; 
tag2(cond2) = 2 ;
tag3(cond3) = 3 ; 
tag4(cond4) = 4 ; 
tag5(cond5) = 5 ; 
tag6(cond6) = 6 ; 


vtime = dataIF.time ;
data = [vtime, proIF, tag1, tag2, tag3, tag4, tag5, tag6 ] ;


%% ����
category = cs.categorize(data);
%% �޳�С������
sless  = 50; % ��������������
[ category.time,id1 ] = cs.excldPa( category.time,sless );
category.pattern(id1)=[];
category.pro(id1)=[];

%% ��Ŀ������ͳ��
% evamat % 2.Ǳ������Ϊ0�ĸ�������������֮�ȣ� 3.Ϊ��ֵ��4.Ϊ���5.Ϊ��λ����6.Ϊƫ�ȣ�7.Ϊ���
[ scoremat,evamat ] = patternscore( category.pro );

