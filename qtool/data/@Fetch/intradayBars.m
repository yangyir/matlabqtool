function [ bs ] = intradayBars( secID, dt, slice_seconds, config )
% ȡ�õ�һ�յ�����Bars�����ڲ���ֻ��һ��
% ���ǹ�Ʊ��config.fuquan д����Ȩ��ʽ��1����Ȩ��2��Ȩ��3ǰ��Ȩ

% �̸գ�20131210

if nargin < 4
    config.fuquan = 1;
end

bs = Fetch.conIntradayBars( secID, dt, dt, slice_seconds, config );


end

