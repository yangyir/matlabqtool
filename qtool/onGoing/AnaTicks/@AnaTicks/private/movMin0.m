function [ r, idx ] = movMin0( ts, len )
%MOVMIN0 移动求最小值
% 假设参数长度为10，则未来计算长度为10，除此外，基数参数当前点；
% movMaxt和movMin未来计算不包括当前点；
% pctCgh作有到期持有量存在，可以与当前点比对；而movMax和movMin往往用于计算潜在风险，不能包括当前点价格（无法买到）；
% 为了与pctChg保持一致，计算时自动作调整。
%   inputs:
%       ts:         时间序列，列向量
%       len:        长度度数，当前点为1；如果len>0，求历史最大；如果len<0，求未来最大。
%   outputs:
%       r:          当前点处于len窗口内的最大最小值
%       idx:        相对位置，向历史计算，包括当前点；未来计算，不包括当前点
%   vesion 1.0, luhuaibao, 2014.6.3

if nargin < 2
    error('参数不足') ;
end ;

timelen = size( ts,1)  ;
if timelen < len
    error('原数据长度不足');
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