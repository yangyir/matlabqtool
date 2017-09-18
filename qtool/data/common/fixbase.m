function [ fixbase_sequence] = fixbase(sequence, position )
%FIXBASE 对一个sequence做定基，相对于指定position
%   sequence      列向量
%   position      单一整数，default = 1
%ver1.0;   Cheng,Gang;     20130411

%% pre-process

% default position = 1
if ~exist('position','var') position =1; end



%% main

fixbase_sequence = sequence / sequence(position) ;





end

