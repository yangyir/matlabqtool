function [ mid, upband, lowband ] =donchian( ClosePrice, nDay )
% Donchian Channel
% default nDay = 20
% daniel 2013/4/18

if ~exist('nDay' , 'var'), nDay  = 20; end

% ���㲽
% �Ͻ���nDay ��hhigh
% �½���nDay ��LLow
% ���½����ǰ��һ��
% ��������(upband+lowband)/2

upband = nan(size(ClosePrice));
lowband = nan(size(ClosePrice));
upband(2:end,:) = ind.hh(ClosePrice(1:end-1,:),nDay);
lowband(2:end,:) = ind.ll(ClosePrice(1:end-1,:),nDay);
mid = (upband + lowband)/2;

end

