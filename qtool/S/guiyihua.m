function [ pos_pct ] = guiyihua( sMat, type, tradableMat )
%GUIYIHUA 归一化sMat
% 不可交易的s没有意义，全部置0
% 入参：
%     sMat
%     tradableMat     默认全部可交易
%     type            'long', 'short', 'long short'(默认）
% 输出：
%     pos_pct         百分比仓位

%% 前处理
NUMasset = size(sMat,2);

if exist('tradableMat', 'var')
    sMat = sMat .* tradableMat;
else    
%     tradableMat = ones(size(sMat)); 
end

if ~exist('type', 'var'), type = 'long short'; end


%% long, short分别算权重
% long
sMat_l = sMat;
sMat_l(sMat_l<0) = 0;
ss_l = sum(sMat_l,2);
pos_pct_l = sMat_l ./ (ss_l*ones(1,NUMasset));

% short
sMat_s = sMat;
sMat_s(sMat_s>0) = 0;
ss_s = sum(sMat_s,2);
pos_pct_s = - sMat_s ./ (ss_s* ones(1,NUMasset));

%% 按type返回不同值
switch type
    case{'long short'}
        pos_pct = pos_pct_l + pos_pct_s;
    case{'long'}
        pos_pct = pos_pct_l;
    case{'short'}
        pos_pct = pos_pct_s;
end


pos_pct(isnan(pos_pct) ) = 0;
end

