function [ vscore_buy,earraybuy ] = patternscore( ppro )
%PATTERNSCORE           对pattern的pro和los进行打分

% 样本个数
% 潜在收益大于亏损占比
% 潜在收益小于亏损占比
% 均值，百分比
% 标准差
% 中值
% 偏度
% 峰度
% 正态检验



n = length(ppro);
vscore_buy = nan(n,1);
earraybuy = nan(n,8);

earraybuy(:,1) = cellfun(@length,ppro);

% var = cellfun(@lengthGiven,ppro);
% % 潜在收益为0的个数与样本总数之比
% earraybuy(:,2) = var./earraybuy(:,1);

% 潜在收益为正或负的个数与样本总数之比
earraybuy(:,2) = cellfun(@(x) sum(x>0),ppro)./earraybuy(:,1);

earraybuy(:,3) = cellfun(@(x) sum(x<0),ppro)./earraybuy(:,1);

earraybuy(:,4) = cellfun(@nanmean,ppro);
earraybuy(:,5) = cellfun(@nanstd,ppro);
earraybuy(:,6) = cellfun(@nanmedian,ppro);

% var = dataclear(ppro);
% var = logv2(var);
% earraybuy(:,6) = cellfun(@skewness,var);
% earraybuy(:,7) = cellfun(@kurtosis,var);

earraybuy(:,7) = cellfun(@skewness,ppro);
earraybuy(:,8) = cellfun(@kurtosis,ppro);

% 正态性检验
earraybuy(:,9) = cellfun(@lillietest,ppro);
% 均值显著性检验
% earraybuy(:,9) = cellfun(@ttest3,ppro);

% 自相关性检验
earraybuy(:,10) = cellfun(@lbqtest,ppro);
% 序号
earraybuy(:,11) = 1:n;

% [~,id1] = sort(-earraybuy(:,2));
% [~,id2] = sort(earraybuy(:,3));
% [~,id3] = sort(earraybuy(:,7));



% 如果sort内的目标量值越大，得分越高，即前不需加-号；如果目标量值越大（如含0的个数），得分越低，则sort时加负号。
[~,id2] = sort(earraybuy(:,2));
[~,id3] = sort(earraybuy(:,3));

[~,id4] = sort(earraybuy(:,4));
[~,id5] = sort(-earraybuy(:,5));
[~,id6] = sort(earraybuy(:,6));
% 偏度可以左偏也可以右偏，因此，只衡量绝对值；但是绝对值越小越好，因此加负号。
[~,id7] = sort( -abs(earraybuy(:,7)) );
[~,id8] = sort(earraybuy(:,8));


vscore_buy(:,1) = cellfun(@length,ppro);  
for i = 1:n
    % id的行号即为排名，因此找到行号对应的原位置即可。
   vscore_buy(i,2) = find(id2==i);    
   vscore_buy(i,3) = find(id3==i);    
   vscore_buy(i,4) = find(id4==i);    
   vscore_buy(i,5) = find(id5==i);      
   vscore_buy(i,6) = find(id6==i);    
   vscore_buy(i,7) = find(id7==i);    
   vscore_buy(i,8) = find(id8==i);  
end

end

