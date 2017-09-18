function [ linked_sequence ] = link2Seq( seq1, seq2, flag )
%LINK2SEQ 先定基，再连接两个sequences       
% 首尾相接的地方视flag而定
% flag = 0 (default)  用乘法, i.e. seq2 = seq2 * seq1(end) 
% flag = 1            用平移，i.e. seq2 = seq2 - ( seq2(1)- seq1(end))
% ver1.0;     Cheng,Gang;         20130411

%% pre-process

% flag默认为0
% if nargin < 3 flag = 0; end
if ~exist('flag', 'var') flag = 0; end


seq1 = fixbase( seq1 );
seq2 = fixbase( seq2 ); 


%% main 

% 处理收尾相接，视flag而定
if flag == 1 
    % 平移连接
    seq2 = seq2 - ( seq2(1)- seq1(end));
else
    %乘法连接
    seq2 = seq2 * seq1(end) ;
end


linked_sequence = [seq1; seq2 ];



end

