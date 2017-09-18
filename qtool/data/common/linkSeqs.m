function [ linked_seq ] = linkSeqs( seq_cell, flag )
%LINKSEQS ���������Ӷ��sequence
%   seq_cell            {seq1, seq2, seq3,...}��ά���������
% ��β��ӵĵط���flag����
%   flag == 0 (default) �ó˷�, i.e. seq2 = seq2 * seq1(end) 
%   flag == 1           ��ƽ�ƣ�i.e. seq2 = seq2 - ( seq2(1)- seq1(end))
% ver1.0;   Cheng,Gang;   20130411

%% pre-process

% flagĬ��Ϊ0
if ~exist('flag', 'var') flag = 0; end


%% main
linked_seq =  fixbase( seq_cell{1});


for i = 2:length(seq_cell)
    seq = fixbase( seq_cell{i} )  ; 
    
    
    if flag == 1
        % ƽ������
        seq = seq - ( seq(1) - linked_seq(end) );
        
    else
        % �˷�����
        seq = seq * linked_seq(end) ;
    end

    
    linked_seq = [linked_seq; seq];
    
end



end

