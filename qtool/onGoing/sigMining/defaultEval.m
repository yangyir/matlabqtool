function [ evalOutValue  ,  evalOutName ] = defaultEval(sig, idx, param)
% 输出分析
% sig 为对象
% idx 为信号发出点的下标序列
% param 为结构化参数
% -----------------
% huajun @20140916

try 
    nStep = param.nStep;
catch err
    nStep =1;
end
try 
    overlap = param.overlap;
catch err
    overlap = 1;
end

idxAll = repmat(idx,1, nStep) + repmat( [1:nStep], length(idx),1);
idxAll = idxAll(:);
idxAll (idxAll > length(sig.time)) = [];

if overlap
    s = sig.ret(idxAll);
else
    s = sig.ret(uique(idxAll));
end


%%%% output contents %%%%%%
j =1;

evalOutValue(j) = length(idx)/sig.nDay;
evalOutName(j) = {'平均每日信号数'};
j = j+1;

evalOutValue(j) = length(s)./length(sig.time);
evalOutName(j) = {'每日信号存在时间占交易时间比率'};
j=j+1;

evalOutValue(j) = sum(s>0)./length(s);
evalOutName(j) = {'信号内样本上升概率'};
j=j+1;

evalOutValue(j) = sum(s<0)./length(s);
evalOutName(j) = {'信号内样本下跌概率'};
j=j+1;

if isfield(param,'retThread')

    evalOutValue(j) = sum(s> abs(param.retThread))./length(s);
    evalOutName(j) = {'上升超过阈值的比率'};
    j = j+1;

    evalOutValue(j) = sum(s< -1*abs(param.retThread))./length(s);
    evalOutName(j) = {'下跌超过阈值的比率'};
    j = j+1;
end


evalOutValue(j) = nanmean(s);
evalOutName(j) = {'样本均值'};
j = j+1;

evalOutValue(j) = nanmedian(s);
evalOutName(j) = {'样本中位数'};   
j = j+1;

evalOutValue(j) = nanstd(s);
evalOutName(j) = {'样本标准差'};
j = j+1;

evalOutValue(j) = skewness(s);
evalOutName(j) = {'样本偏度'};
j = j+1;

evalOutValue(j) = kurtosis(s);
evalOutName(j) = {'样本峰度'};
j = j+1;

%%%%%%%%
% other evaluators
%%%%%%%%%
  
end % end of defaultEval
   