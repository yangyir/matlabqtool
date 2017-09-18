function [ r ] = tagging2( data, flag , kp)
%TAGGING2            �����зֵ�����tagging��Ԫ����
%   inputs:
%   data            ԭ������
%   kp              number of category
%   flag            �ֵ���ʽ��1Ϊ����֣���Ϊ1���������kp��2 Ϊ��ȥ10��K������ͳ�ƣ�3Ϊ����kp���ľ���ֵ����
%   outputs:
%   r               r �ṹ�������r.data
%   demo:
%       a=randi([1,10],5,1)
%       b=cs.tagging2(a,3,[1,3,5,7,9])

switch flag
    case 1
        nc = length(kp) + 1;
        vstd = nanstd(data);
        vmean = nanmean(data);
        r = nan(length(data),1);
        for i = 1:nc
            if i==1
                r(data < vmean + kp(i)*vstd) = 1;
            elseif i==nc
                r(data >= vmean + kp(i-1)*vstd) = i ;
            else r( data< vmean + kp(i)*vstd & data >= vmean + kp(i-1)*vstd ) = i;
            end;
                    
        end;
        
    case 2
        nx = length(data);
        r = nan(nx,1);
        for i = 10:nx
            r(i) = sum(data(i-9:i));                    
        end;  
        
    case 3
        nc = length(kp) + 1;
        vstd = 1;
        vmean = 0;
        r = nan(length(data),1);
        for i = 1:nc
            if i==1
                r(data < vmean + kp(i)*vstd) = 1;
            elseif i==nc
                r(data >= vmean + kp(i-1)*vstd) = i ;
            else r( data< vmean + kp(i)*vstd & data >= vmean + kp(i-1)*vstd ) = i;
            end;
                    
        end;        

end;



end

