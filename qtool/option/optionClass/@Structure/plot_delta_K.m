function [ hfig ] = plot_delta_K( self , K )
%PLOT_DELTA_K ��delta~K��ͼ
% ---------------------
% ���Ʒ壬20160129
% ���Ʒ壬20160229������һ���Ƚ��µĸ�ԭ����
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����

% ��ȡ���Ƶ�����
copy  = self.getCopy();

%% ��ͼ

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

[ L1 , L2 ] = size( copy.optPricers );

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).K = K;
    end
end

copy.calcDelta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( K , copy.delta );

legend('delta');
xlabel('K')
ylabel('delta')
grid on;
txt = 'Structure��Ȩ���delta��K�ĺ���ͼ';
title( txt )

hold off

end

