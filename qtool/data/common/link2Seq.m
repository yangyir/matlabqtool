function [ linked_sequence ] = link2Seq( seq1, seq2, flag )
%LINK2SEQ �ȶ���������������sequences       
% ��β��ӵĵط���flag����
% flag = 0 (default)  �ó˷�, i.e. seq2 = seq2 * seq1(end) 
% flag = 1            ��ƽ�ƣ�i.e. seq2 = seq2 - ( seq2(1)- seq1(end))
% ver1.0;     Cheng,Gang;         20130411

%% pre-process

% flagĬ��Ϊ0
% if nargin < 3 flag = 0; end
if ~exist('flag', 'var') flag = 0; end


seq1 = fixbase( seq1 );
seq2 = fixbase( seq2 ); 


%% main 

% ������β��ӣ���flag����
if flag == 1 
    % ƽ������
    seq2 = seq2 - ( seq2(1)- seq1(end));
else
    %�˷�����
    seq2 = seq2 * seq1(end) ;
end


linked_sequence = [seq1; seq2 ];



end

