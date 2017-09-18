function [ sig_long, sig_short ] = pos2trade(   sig_rs  )
% ���ֲ��ź�תΪ��ƽ���ź�
% [ sig_long, sig_short ] = pos2trade(   sig_rs  )
% ���룺 Ϊtai������Ĭ�ϵ�����ֲ�/ǿ���źţ�sig_rs)
% ����� Ϊtai������Ĭ��ǰ�����ͷ��ƽ��sig_long���Ϳ�ͷ��ƽ��sig_short���ź�
% �˺����ķ������Ϊ trade2pos
% ת��������
% sig_rs  sig_long    sig_short
%   1        
%   0        -1          0    
% -----------------------------
% sig_rs  sig_long    sig_short
%   1        
%   -1       -1          -1    
% -----------------------------
% sig_rs  sig_long    sig_short
%   0        
%   1        1          0    
% -----------------------------
% sig_rs  sig_long    sig_short
%   0        
%   -1        0          -1    
% -----------------------------
% ���ղ�����෴
% @author   daniel  20130507

[ nPeriod, nAsset ] = size(sig_rs);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);

%���㲽

for jAsset = 1: nAsset
    rs_last = 0;
    for iPeriod = 1: nPeriod
        rs_now = sig_rs(iPeriod, jAsset);
        if rs_now == rs_last
            continue;
        elseif rs_last == 1
            sig_long(iPeriod, jAsset) = -1;
            if rs_now == -1
                sig_short(iPeriod, jAsset) = -1;
            end
        elseif rs_last ==0 
            if rs_now == 1
                sig_long(iPeriod, jAsset) = 1;
            else
                sig_short(iPeriod, jAsset) = -1;
            end
        elseif rs_last == -1
            sig_short(iPeriod, jAsset) = 1;
            if rs_now == 1
                sig_long(iPeriod, jAsset) = 1;
            end
        end
        rs_last = sig_rs(iPeriod, jAsset);
    end
end

        

