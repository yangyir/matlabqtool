function [ vscore_buy,earraybuy ] = patternscore( ppro )
%PATTERNSCORE           ��pattern��pro��los���д��

% ��������
% Ǳ��������ڿ���ռ��
% Ǳ������С�ڿ���ռ��
% ��ֵ���ٷֱ�
% ��׼��
% ��ֵ
% ƫ��
% ���
% ��̬����



n = length(ppro);
vscore_buy = nan(n,1);
earraybuy = nan(n,8);

earraybuy(:,1) = cellfun(@length,ppro);

% var = cellfun(@lengthGiven,ppro);
% % Ǳ������Ϊ0�ĸ�������������֮��
% earraybuy(:,2) = var./earraybuy(:,1);

% Ǳ������Ϊ���򸺵ĸ�������������֮��
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

% ��̬�Լ���
earraybuy(:,9) = cellfun(@lillietest,ppro);
% ��ֵ�����Լ���
% earraybuy(:,9) = cellfun(@ttest3,ppro);

% ������Լ���
earraybuy(:,10) = cellfun(@lbqtest,ppro);
% ���
earraybuy(:,11) = 1:n;

% [~,id1] = sort(-earraybuy(:,2));
% [~,id2] = sort(earraybuy(:,3));
% [~,id3] = sort(earraybuy(:,7));



% ���sort�ڵ�Ŀ����ֵԽ�󣬵÷�Խ�ߣ���ǰ�����-�ţ����Ŀ����ֵԽ���纬0�ĸ��������÷�Խ�ͣ���sortʱ�Ӹ��š�
[~,id2] = sort(earraybuy(:,2));
[~,id3] = sort(earraybuy(:,3));

[~,id4] = sort(earraybuy(:,4));
[~,id5] = sort(-earraybuy(:,5));
[~,id6] = sort(earraybuy(:,6));
% ƫ�ȿ�����ƫҲ������ƫ����ˣ�ֻ��������ֵ�����Ǿ���ֵԽСԽ�ã���˼Ӹ��š�
[~,id7] = sort( -abs(earraybuy(:,7)) );
[~,id8] = sort(earraybuy(:,8));


vscore_buy(:,1) = cellfun(@length,ppro);  
for i = 1:n
    % id���кż�Ϊ����������ҵ��кŶ�Ӧ��ԭλ�ü��ɡ�
   vscore_buy(i,2) = find(id2==i);    
   vscore_buy(i,3) = find(id3==i);    
   vscore_buy(i,4) = find(id4==i);    
   vscore_buy(i,5) = find(id5==i);      
   vscore_buy(i,6) = find(id6==i);    
   vscore_buy(i,7) = find(id7==i);    
   vscore_buy(i,8) = find(id8==i);  
end

end

