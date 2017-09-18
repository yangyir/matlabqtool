function [ hfig ] = plot_gamma_tau( self )
%PLOT_GAMMA_TAU ��gamma~tau��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

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

copy.calcGamma();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( tau, copy.gamma );

xlabel('\tau')
ylabel('gamma')

grid on;
txt = 'Structure��Ȩ���gamma��\tau�ĺ���ͼ';

title(txt)

hold off

end

