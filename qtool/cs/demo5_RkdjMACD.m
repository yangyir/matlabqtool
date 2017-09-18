% 对Rkdj和MACD做统计
% luhuaibao, 2013.11.4


%% 数据处理
clc
clear
close all

%% 加载固态数据
load('dataIF.mat');
%% 计算目标量

load('potenPL.mat');
proIF(isnan(proIF)) = 0;
losIF(isnan(losIF)) = 0;
proIF = proIF + losIF;


 
bars = dataIF ; 
% 参数设置
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
%% 计算macd
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


%% 分类
category = cs.categorize(data);
%% 剔除小样本类
sless  = 50; % 类内最少样本数
[ category.time,id1 ] = cs.excldPa( category.time,sless );
category.pattern(id1)=[];
category.pro(id1)=[];

%% 对目标量的统计
% evamat % 2.潜在收益为0的个数与样本总数之比， 3.为均值，4.为方差，5.为中位数，6.为偏度，7.为峰度
[ scoremat,evamat ] = patternscore( category.pro );

