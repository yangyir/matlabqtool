function [ outSeq ] = expDecay(      inSeq, days )
%EXPDACAY 指数衰减n天作为权重，影响后面的日子，加权平均
% 理论上，n->inf时， mv.expDecay(s, n) -> mv.expSmooth(s, 1 - 1/e)
% 程刚，20140913

%% 前处理 

if ~exist('days','var'), days = 0; end
days = round(days);
if days<0,     days =0;  end




%% 挑出非nan的干净的inSeq, 并留下index
inSeq2 = inSeq(~isnan(inSeq));
idx = find(~isnan(inSeq));


%% 计算干净的　inSeq -> outSeq
N = length(inSeq2);

% 算出矩阵
mat     = nan(N, days+1);
wtmat   = nan(N,days+1);
% mat(:,1) = inSeq2;
% wtmat(:,1) = exp(0);

for dt = 1:days+1
    wtmat(dt:end ,dt)   = exp(-dt);
    mat( dt:end ,dt)    = inSeq2(1:end-dt+1) * exp(-dt);
end

% 按行求加权后均值
outSeq2 = nan(N,1);
for i = 1:N
    outSeq2(i) = nansum(mat(i,:))  /  nansum(wtmat(i,:));
end


%% 还原outSeq中的nan
outSeq = nan(size(inSeq));
outSeq(idx) = outSeq2;

end

