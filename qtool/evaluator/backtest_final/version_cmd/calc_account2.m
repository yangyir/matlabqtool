%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于各种证券每天成交量、持有量和资产总值。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [Volume,Account] = calc_account2(marketdata,input1,input2)

len  = size(marketdata{1},1);
seu_num = size(input1,2);

Volume = zeros(len-1,seu_num);
Account =  zeros(len,1);
% 计算成交量
Date = marketdata{1};
Date = Date(:,1);
 
for Index1 = 1:len-1
     Temp =input2(input2(:,1) == Date(Index1,1),2:end);
     if ~isempty(Temp)
         Volume(Index1,:) = Temp;
     end
end
% 计算持有量
Asset = cumsum([cell2mat(input1(2,:));Volume]);


price = ones(seu_num,len);

for Index2 = 2:seu_num
    price(Index2,:) = (marketdata{Index2-1}(:,2))';
end

% 计算资产总值
for Index3 = 1:len
    Account (Index3) = Asset(Index3,:) * price(:,Index3); % 还需加上债券的利息以及再投资收益
end


end