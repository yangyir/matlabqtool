function [ output_args ] = plotind( obj, ind, showcond, drawtype)
%PLOTIND shows indicated places on a K Chart
% [ output_args ] = plotind( obj, ind, showcond, drawtype)
%   ind             vector of indicating values
%   showcond        show condition, eg. '==2', '>0'��default) 
%   drawtype        color and shape, eg. '*r'(default)
% ----------------------------------------------------------------
% ver1.0;  Cheng,Gang;     20130409
% ver1.1; Cheng,Gang; 20130411; ����showcond����ind��ȡֵ��Χ����
% ver1.2; Cheng,Gang; 20130411; ֻ���㣬�ص���ʾ�������ں��������н��
% ver1.3; Cheng,Gang; 20130419; show = nan(length(obj.vwap),1); ����obj.lenΪ��

%% pre-process
if ~exist('drawtype','var'), drawtype = '*r'; end
if ~exist('showcond','var'), showcond = '>0'; end
 

%% main

len = length(obj.vwap);
if len ==0, return;
    
% draw 1: indicated places
show = nan(length(obj.vwap),1);
eval(['idx = ind' showcond ';'] );
show( idx ) = obj.vwap( idx );
% eval( [ 'show( ind', showcond, ') = obj.vwap( ind', showcond, ');' ]);
plot(show, drawtype);



end

