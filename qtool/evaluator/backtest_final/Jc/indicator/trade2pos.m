function  [  sig_rs  ]  = trade2pos(sig_long, sig_short)
% ��ƽ���ź�ת��Ϊ��λ/ǿ���ź�
% [  sig_rs  ]  = trade2pos(sig_long, sig_short)
% ���룺   Ϊtai������Ĭ��ǰ�����������ͷ��ƽ��sig_long���Ϳ�ͷ��ƽ��sig_short���ź�
% �����   Ϊtai������Ĭ�ϵ�����������ֲ�/ǿ���źţ�sig_rs)
% �����㣺 �󲿷�ָ��ֻ���������źţ����ǳֲ��źš�
% ת�������� sig_long    sig_short   sig_rs
%               1           0           1
%               0           0           1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%              -1           0           0
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               0          -1           -1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               1          -1           1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               0           0           0
%               1          -1           0
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               1           0           1
% ��ͷsig_short ���������sig_long, ֻ�ǿ����ź�Ϊ -1
% 
% @author   daniel  20130507

[nPeriod, nAsset] = size(sig_long);
sig_rs = zeros(nPeriod, nAsset);

% ���㲽
% rs_last   nowLong     nowShort
%   1           1           1
%   0           0           0
%  -1          -1          -1

for jAsset = 1: nAsset
    rs_last = 0; 
    for iPeriod = 1 : nPeriod
        nowLong = sig_long(iPeriod, jAsset);
        nowShort = sig_short(iPeriod, jAsset);
    
        % �ֲ� = 1 ������
        rsLong =    rs_last ==1     &   nowLong == 1 ||...
                    rs_last + nowLong == 1  & nowShort >=0 ||...
                    rs_last == -1   &   nowLong  ==1 & nowShort >= 0;

        % �ֲ� = 0 ������
        rsZero =    rs_last == 1    &   nowLong == -1 & nowShort >=0 ||...
                    rs_last == -1   &   nowLong ~= 1  & nowShort ==1 ||...
                    rs_last == 0    &   nowLong + nowShort == 0     ||...
                    rs_last == 0    &   nowLong == -1 & nowShort == 0 ||...
                    rs_last == 0    &   nowLong == 0  & nowShort == 1;

        % �ֲ� = -1 ������ 
        rsShort =   rs_last == -1   &   nowShort == -1 ||...
                    rs_last + nowShort == -1  & nowLong  <= 0 ||...
                    rs_last == 1    &   nowShort == -1 & nowLong <= 0 ;
            
        if rsLong
            sig_rs(iPeriod, jAsset) = 1;
        end
        if rsZero
            sig_rs(iPeriod, jAsset) = 0;
        end
        if rsShort
            sig_rs(iPeriod, jAsset) = -1;
        end
        rs_last = sig_rs(iPeriod, jAsset);
    end
end

end %EOF
       
       
        
        
        
        
        
        
        