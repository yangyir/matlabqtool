%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڸ���֤ȯÿ��ɽ��������������ʲ���ֵ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [Volume,Account] = calc_account2(marketdata,input1,input2)

len  = size(marketdata{1},1);
seu_num = size(input1,2);

Volume = zeros(len-1,seu_num);
Account =  zeros(len,1);
% ����ɽ���
Date = marketdata{1};
Date = Date(:,1);
 
for Index1 = 1:len-1
     Temp =input2(input2(:,1) == Date(Index1,1),2:end);
     if ~isempty(Temp)
         Volume(Index1,:) = Temp;
     end
end
% ���������
Asset = cumsum([cell2mat(input1(2,:));Volume]);


price = ones(seu_num,len);

for Index2 = 2:seu_num
    price(Index2,:) = (marketdata{Index2-1}(:,2))';
end

% �����ʲ���ֵ
for Index3 = 1:len
    Account (Index3) = Asset(Index3,:) * price(:,Index3); % �������ծȯ����Ϣ�Լ���Ͷ������
end


end