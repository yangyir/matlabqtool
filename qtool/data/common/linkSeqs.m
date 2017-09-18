function [ linked_seq ] = linkSeqs( seq_cell, flag )
%LINKSEQS 定基后连接多个sequence
%   seq_cell            {seq1, seq2, seq3,...}，维数不必相等
% 首尾相接的地方视flag而定
%   flag == 0 (default) 用乘法, i.e. seq2 = seq2 * seq1(end) 
%   flag == 1           用平移，i.e. seq2 = seq2 - ( seq2(1)- seq1(end))
% ver1.0;   Cheng,Gang;   20130411

%% pre-process

% flag默认为0
if ~exist('flag', 'var') flag = 0; end


%% main
linked_seq =  fixbase( seq_cell{1});


for i = 2:length(seq_cell)
    seq = fixbase( seq_cell{i} )  ; 
    
    
    if flag == 1
        % 平移连接
        seq = seq - ( seq(1) - linked_seq(end) );
        
    else
        % 乘法连接
        seq = seq * linked_seq(end) ;
    end

    
    linked_seq = [linked_seq; seq];
    
end



end

