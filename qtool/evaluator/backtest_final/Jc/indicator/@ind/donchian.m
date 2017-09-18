function [ mid, upband, lowband ] =donchian( ClosePrice, nDay )
% Donchian Channel
% default nDay = 20
% daniel 2013/4/18

if ~exist('nDay' , 'var'), nDay  = 20; end

% 计算步
% 上界是nDay 的hhigh
% 下界是nDay 的LLow
% 上下界均向前移一天
% 中心线是(upband+lowband)/2

upband = nan(size(ClosePrice));
lowband = nan(size(ClosePrice));
upband(2:end,:) = ind.hh(ClosePrice(1:end-1,:),nDay);
lowband(2:end,:) = ind.ll(ClosePrice(1:end-1,:),nDay);
mid = (upband + lowband)/2;

end

