function [d, dseq  ] = dis( seq, span )
%DIS ����һ��vector���߹��ľ���
% ���룺
%     ts  : ��vector
%     span: �������ȣ�Ĭ��1
% �����
%     d   : �ܾ���
%     dseq: ��������
% ver 1.0; Cheng,Gang; 20130723


%% pre-process


%% main
dseq =[0; diff(seq)];
dseq = cumsum(abs(dseq));
% dist = cumsum(dist);

d = dseq(end);


end

