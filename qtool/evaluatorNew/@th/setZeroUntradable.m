function [ tradeMat ] = setZeroUntradable ( tradeMat, tradableMat )
% 把不可交易的地方置为0，最简单粗暴的处理方式
% [ tradeMat ] = setZeroUntradalbe ( tradeMat, tradableMat )
%     tradeMat： 交易矩阵，TsMatrix类
%     tradableMat：可交易1，不可0，TsMatrix类。默认从DH取
% ---------
% 程刚，20150521，初版本


%% 前处理
% 判断类型
if ~isa(tradeMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeMat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeMat );
end


% 打开DH


%% main 
tradeMat.data = tradeMat.data  .*  tradableMat.data;


end

