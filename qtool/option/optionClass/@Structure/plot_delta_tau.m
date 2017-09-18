function [ hfig ] = plot_delta_tau( self )
%PLOT_DELTA_TAU ��delta~tau��ͼ
% ---------------------
% ���Ʒ壬20160129
% ���Ʒ壬20160316��ʹ��copy�ķ���������ͼ

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% ��ͼ

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

copy.calcDelta;

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( tau, copy.delta );

xlabel('\tau')
ylabel('delta')

grid on;
txt = 'Structure��Ȩ�����Ȩdelta��\tau�ĺ���ͼ';
title( txt )

hold off

end

