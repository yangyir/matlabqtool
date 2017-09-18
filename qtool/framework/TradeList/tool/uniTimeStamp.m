function [ idx ] = uniTimeStamp( X, Y )
%UNITIMESTAMP,����YΪ�߶ȵ�ʱ������ת��Ϊ��XΪ�߶ȵ�ʱ�����С�idx�ĳ���
% ��X��ͬ��ΪY -> X ��ӳ�����ꡣ
% ת����ʱ�����ǰ����������ѹ���ķ�ʽ��
%
% Ҫ��֤ X �� Y ��������ġ�

lenRuler = length(X);
lenRod = length(Y);

idx = nan(lenRuler,1);
%%
iY = 1;
flag = true;
for iX = 1:length(X)
    while Y(iY)<=X(iX)
        % ���֮�俿����Y���ҵ����������ʱ��ĵ�һ����
        iY = iY+1;
        if iY>lenRod
            idx(iX:end) = iY-1;
            flag = false;
            break;
        end
    end
    
    if flag 
        idx(iX) = iY-1;
    else
        break;
    end
end

%% ��������

ind = idx == 0;

idx(ind) = 1;


end

