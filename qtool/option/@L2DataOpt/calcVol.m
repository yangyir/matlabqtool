function [ obj ] = calcVol( obj , R, S)
%CALCVOL 算一遍vol
% 输入：
%     R - 无风险利率，默认6%
%     S - 资产价格
% ---------------------------------------------------     
% 程刚，151119

%% 默认值
if ~exist('R', 'var'), R = 0.06; end
if ~exist('S', 'var'), S = 2.291; end


%% 基础版：全部重算一遍
% tic
try
if obj.CP == 1 % call
    res = blsimpv(S, obj.K, R, obj.T, [obj.last, obj.askP1, obj.bidP1], 3, 0, [], {'call'});
    obj.vol = res(1);
    obj.askvol = res(2);
    obj.bidvol = res(3);
elseif obj.CP == 2 % put
    res = blsimpv(S, obj.K, R, obj.T, [obj.last, obj.askP1, obj.bidP1], 3, 0, [], {'put'});
    obj.vol = res(1);
    obj.askvol = res(2);
    obj.bidvol = res(3);    
end
catch e, end
% toc

%% 改进版：只计算改变了价格的计算值
% obj.changedL2fields





end

