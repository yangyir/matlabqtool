function [ r, idx ] = movMin0( ts, len )
%MOVMIN0 �ƶ�����Сֵ
% �����������Ϊ10����δ�����㳤��Ϊ10�������⣬����������ǰ�㣻
% movMaxt��movMinδ�����㲻������ǰ�㣻
% pctCgh���е��ڳ��������ڣ������뵱ǰ��ȶԣ���movMax��movMin�������ڼ���Ǳ�ڷ��գ����ܰ�����ǰ��۸��޷��򵽣���
% Ϊ����pctChg����һ�£�����ʱ�Զ���������
%   inputs:
%       ts:         ʱ�����У�������
%       len:        ���ȶ�������ǰ��Ϊ1�����len>0������ʷ������len<0����δ�����
%   outputs:
%       r:          ��ǰ�㴦��len�����ڵ������Сֵ
%       idx:        ���λ�ã�����ʷ���㣬������ǰ�㣻δ�����㣬��������ǰ��
%   vesion 1.0, luhuaibao, 2014.6.3

if nargin < 2
    error('��������') ;
end ;

timelen = size( ts,1)  ;
if timelen < len
    error('ԭ���ݳ��Ȳ���');
end ;

r = nan( timelen,1 ) ;
idx = nan(timelen,1) ;

if len > 0
    for i = 1:timelen
        if i < len
            [r(i),idx(i)] = min( ts(1:i) ) ; 
        end ; 
        
        if i>= len 
            [r(i),idx(i)] = min( ts(i-len+1:i) ) ; 
        end ; 
    end ;
end ;

if len < 0
    for i = 1:timelen
        if i> timelen+len && i < timelen
            [r(i),idx(i)] = min( ts(i+1:end) ) ; 
        end ; 
        
        if i<= timelen+len 
            [r(i),idx(i)] = min( ts(i+1:i-len ) ) ; 
        end ; 
    end ;
end ;


end