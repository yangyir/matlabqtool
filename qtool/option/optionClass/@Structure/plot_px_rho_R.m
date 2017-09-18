function [ hfig ] = plot_px_rho_R( self )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

r = 0.005:0.005:0.095;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).r = r;
    end
end

copy.calcPx();
copy.calcRho();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% px~R
subplot(211)
plot( r , copy.px );
grid on
txt = '��Ȩ���Structure�۸��R�ĺ���ͼ';
title(txt)
xlabel('R')
ylabel('px')

% rho~R
subplot(212)
plot( r , copy.rho );
grid on
txt = '��Ȩ���Structure��Rho��R�ĺ���ͼ';
title(txt)
xlabel('R')
ylabel('Rho')

hold off

end
