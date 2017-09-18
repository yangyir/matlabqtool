function subacc = account_split(ori_account,Ind)
% 根据原始的时间序列 ori_account 以及分段的Ind，计算
% 出子序列ori_account(Ind)的中每段按上一段的最后数值保持比例不变的新序列。
% 输出为一个列向量的形式
% by Zehui Wu version 1.0 2013/7/3

EndInd = find(diff(Ind)>=2);%每段连续Ind的结束的Ind的index
%分配subacc的内存
subacc = zeros(length(Ind),1);
if ~isempty(EndInd)
    %第一段直接平移
    tmpsubacc = ori_account(Ind(1):Ind(EndInd(1)));
    subacc(1:length(tmpsubacc)) = tmpsubacc;
    endofsubacc = length(tmpsubacc)+1;
    %第二段至倒数第二段调整
    for i = 2:length(EndInd)
%         tmpsubacc = ori_account(Ind(EndInd(i-1)+1):Ind(EndInd(i)))...
%             *subacc(endofsubacc-1)/ori_account(Ind(EndInd(i-1)+1));
        tmpsubacc = ori_account(Ind(EndInd(i-1)+1):Ind(EndInd(i)))...
            +subacc(endofsubacc-1)-ori_account(Ind(EndInd(i-1)+1));
        subacc(endofsubacc:endofsubacc+length(tmpsubacc)-1) = tmpsubacc;
        endofsubacc = endofsubacc+length(tmpsubacc);
    end
    %最后一段的调整
%     tmpsubacc = ori_account(Ind(EndInd(end)+1):Ind(end))...
%         *subacc(endofsubacc-1)/ori_account(Ind(EndInd(end)+1));
tmpsubacc = ori_account(Ind(EndInd(end)+1):Ind(end))...
         +subacc(endofsubacc-1)-ori_account(Ind(EndInd(end)+1));
    subacc(endofsubacc:end) = tmpsubacc;
else
    %没有跳点
    subacc=ori_account;
end
%subacc计算完毕
end