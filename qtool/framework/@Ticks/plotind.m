function [ output_args ] = plotind( obj, idx, drawtype)
%PLOTIND��Ticks�ϻ�Ҫ��ʾ�ĵ�
% [   ] = plotind( obj, idx, drawtype)
%   idx             ֱ�Ӹ�Ҫ����index�� �� tks.last > 100
%   drawtype        color and shape, eg. '*r'(default)
% ----------------------------------------------------------------
% ver1.0;  Cheng,Gang;     20130409
% ver1.1; Cheng,Gang; 20130411; ����showcond����ind��ȡֵ��Χ����
% ver1.2; Cheng,Gang; 20130411; ֻ���㣬�ص���ʾ�������ں��������н��
% ver1.3; Cheng,Gang; 20130419; show = nan(length(obj.vwap),1); ����obj.lenΪ��
% �̸գ�140731��showcondȥ����ֱ�Ӿ���idx������

%% pre-process
if ~exist('drawtype','var') drawtype = '*r'; end
 

%% main
% figure
% hold on;

len = length(obj.last);
if len ==0, return; end
    
% draw 1: indicated places
show = nan(len,1);
% eval(['idx = ind' showcond ';'] );
show( idx ) = obj.last( idx );
% eval( [ 'show( ind', showcond, ') = obj.vwap( ind', showcond, ');' ]);
plot(show, drawtype);

end

