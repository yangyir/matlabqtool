function  [outSeq]    = delta(    inSeq, window )
%DELTA ȡ�������еĲ�
% window����أ���ʷ��λ�Ƶĳ��ȣ���Ϊ��ֵ������󣨽�����λ��
% �����ʽ�ǣ�inSeq - λ�ƺ�inSeq
% window Ĭ��1


%% 
if ~exist('window','var'), window = 1; end

%% 
outSeq = nan(size(inSeq));
outSeq(window+1:end) = inSeq(window+1:end) - inSeq(1:end-window);


end

