function [ pxy, ttl_cnt ] = PXY( x,y,plotflag,xnodes,ynodes )
%PXY �������ϸ���P(XY)���ɽ���x,yȡֵ��ɢ������
% ������ѧϰ�ߣ�����������ĸ��д���������X��Y��д
% inputs::
%   x         :vector����������x��y����ͬά��
%   y         :vector��������
%   xnodes    :x���ֽڵ㣬���ұգ�Ĭ��20�ȷ�
%   ynodes    :y���ֽڵ㣬���ұգ�Ĭ��20�ȷ�
%   plotflag  :1��ͼ�� 0����ͼ��Ĭ�ϣ�
% outputs::
%   pxy       :���ϸ��ʷֲ���ʵ��Ƶ���ֲ���
%   ttl_cnt   :�ܼ��������ڹ��������Ч��
% ----------------------------------------------------
% ver1.0; Cheng,Gang; 20130417; 

%% pre-process

if ~exist('plotflag','var') plotflag = 0 ; end

% xnodes Ĭ��ֵ������ɢ�������������
if ~exist('xnodes', 'var')
    
    mn      = nanmin(x);
    mx      = nanmax(x);
    xnodes  = unique(x);
    
    % ��x��ɢ��ֱ��ȡֵ�����ұ�
    if length(xnodes) < 20
        xnodes      = [mn - (mx-mn)/20; xnodes];
    
    % ��x������20�ȷ֣�min��max]�����ұ�
    else    
        xnodes      = linspace( mn, mx, 20);
%         xnodes(1)   = mn - (mx-mn)/20;
    end
    
end

% ynodes Ĭ��ֵ������ɢ�������������
if ~exist('ynodes', 'var')
    
    mn      = nanmin(y);
    mx      = nanmax(y);
    ynodes  = unique(y);
    
    % ��x��ɢ��ֱ��ȡֵ�����ұ�
    if length(ynodes) < 20
        ynodes      = [mn - (mx-mn)/20; ynodes];
    
    % ��x������20�ȷ֣�min��max]�����ұ�
    else
        ynodes      = linspace( mn, mx, 20);
%         ynodes(1)   = mn - (mx-mn)/20;
    end
    
end




%% main

ttl_cnt = length(x);
lenx    = length(xnodes);
leny    = length(ynodes);
pxy     = nan(lenx, leny);

%Ƶ��ͳ��
for ix = 1:lenx - 1
    for iy = 1: leny -1
        count = nansum(   x >   xnodes(ix) ... 
                        & x <=  xnodes(ix+1) ...
                        & y >   ynodes(iy) ...
                        & y <=  ynodes(iy+1));
        pxy(ix+1,iy+1) = count/ttl_cnt; 
    end
end

%% plot 
if plotflag == 1 
    figure
    surf(xnodes', ynodes', pxy');
end
end

