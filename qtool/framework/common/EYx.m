function [EY_x, xnodes, xcount] = EYx( x, y, plotflag, xnodes  )
% EYx �������� E(Y|X = x)
% ������ѧϰ�ߣ�����������ĸ��д���������Y��д����������xСд
% inputs:
%   x         :X��vector, x,y ��ͬ����
%   y         :Y��vector
%   xnodes    :x�Ļ��ֵ㣬Ĭ�Ͼ���20�࣬���ұ�
%   plotflag  : ==1��ͼ, ==0�򲻻���Ĭ�ϣ�
% output��
%   EY_x      :����x��Y������ ����x�ĺ�����  
%   xnodes    :ͬinput
%   xcount    :ÿ�������еĵ�����������ڼ��������ԣ�
% -------------------------------------------------------
% ver1.0; Cheng,Gang; 20130416

%% pre-process

% plotflag Ĭ��1����ͼ
if ~exist('plotflag','var') plotflag = 0; end

% xnodes Ĭ��ֵ������ɢ�������������
if ~exist('xnodes', 'var')
    
    mn      = nanmin(x);
    mx      = nanmax(x);
    xnodes  = unique(x);
    
    % ��x��ɢ��ֱ��ȡֵ�����ұ�
    if length(xnodes) < 20
        xnodes = [mn - (mx-mn)/20; xnodes];
    
    % ��x������20�ȷ֣�min��max]�����ұ�
    else    
        xnodes      = linspace( mn, mx, 20);
%         xnodes(1)   = mn - (mx-mn)/20;
    end
    
end
%% main

lenx    = length(xnodes);
EY_x     = nan(lenx,1);
xcount  = nan(lenx,1);

for ix = 1:lenx - 1
    EY_x(ix+1)   = nanmean( y ( x > xnodes(ix) & x <= xnodes(ix+1)) );  
    xcount(ix+1)= nansum(  x > xnodes(ix) & x <= xnodes(ix+1) );
end

%% plot to check right

if plotflag == 1
    figure
    subplot
    
    subplot(2,1,1)
    plot( xnodes, EY_x, '-*');
    
    subplot(2,1,2)
    bar(xnodes, xcount)
end

end

