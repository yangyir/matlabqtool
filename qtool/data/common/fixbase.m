function [ fixbase_sequence] = fixbase(sequence, position )
%FIXBASE ��һ��sequence�������������ָ��position
%   sequence      ������
%   position      ��һ������default = 1
%ver1.0;   Cheng,Gang;     20130411

%% pre-process

% default position = 1
if ~exist('position','var') position =1; end



%% main

fixbase_sequence = sequence / sequence(position) ;





end

