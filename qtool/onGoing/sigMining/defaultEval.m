function [ evalOutValue  ,  evalOutName ] = defaultEval(sig, idx, param)
% �������
% sig Ϊ����
% idx Ϊ�źŷ�������±�����
% param Ϊ�ṹ������
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
evalOutName(j) = {'ƽ��ÿ���ź���'};
j = j+1;

evalOutValue(j) = length(s)./length(sig.time);
evalOutName(j) = {'ÿ���źŴ���ʱ��ռ����ʱ�����'};
j=j+1;

evalOutValue(j) = sum(s>0)./length(s);
evalOutName(j) = {'�ź���������������'};
j=j+1;

evalOutValue(j) = sum(s<0)./length(s);
evalOutName(j) = {'�ź��������µ�����'};
j=j+1;

if isfield(param,'retThread')

    evalOutValue(j) = sum(s> abs(param.retThread))./length(s);
    evalOutName(j) = {'����������ֵ�ı���'};
    j = j+1;

    evalOutValue(j) = sum(s< -1*abs(param.retThread))./length(s);
    evalOutName(j) = {'�µ�������ֵ�ı���'};
    j = j+1;
end


evalOutValue(j) = nanmean(s);
evalOutName(j) = {'������ֵ'};
j = j+1;

evalOutValue(j) = nanmedian(s);
evalOutName(j) = {'������λ��'};   
j = j+1;

evalOutValue(j) = nanstd(s);
evalOutName(j) = {'������׼��'};
j = j+1;

evalOutValue(j) = skewness(s);
evalOutName(j) = {'����ƫ��'};
j = j+1;

evalOutValue(j) = kurtosis(s);
evalOutName(j) = {'�������'};
j = j+1;

%%%%%%%%
% other evaluators
%%%%%%%%%
  
end % end of defaultEval
   