function [ outSeq ]  = dndn( inSeq )
% MV.DNDN ����moving �����µ��Ĳ���,windowû������
% ���룺
%     inSeq   : N*1 ������
% �����
%     outSeq  : N*1 ��������1:windowΪnan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process

% seq �Ǽ�����



%% main
N = length(inSeq);
outSeq = nan(N,1);

dif = diff(inSeq);
updn = zeros(N,1);
updn(dif<0) = 1;
 
cnt = 0;
for i = 1:N-1
    cnt = (cnt + 1)* updn(i);  
    outSeq(i+1) = cnt;
end


end



