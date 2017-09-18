function [ hfig ] = plot_delta_S( self , S )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% ���Ʒ壬20160129
% ���Ʒ壬20160229������һ���Ƚ��µĸ�ԭ����
% ���Ʒ壬20160316��ģ�¸ո��޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

% ����SĬ��ֵ��
if ~exist( 'S' , 'var' )
    center = copy.optPricers(1,1).S;
    try
        wrong =  center == 0 || isempty(center) || isnan(center);
        if wrong,  center = pricer.K; end    
    catch e
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end

copy.calcDelta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( S , copy.delta );
legend('delta');

xlabel('S')
ylabel('delta')

grid on;
txt = 'Structure��Ȩ���delta��S�ĺ���ͼ';
title(txt)

hold off

end

