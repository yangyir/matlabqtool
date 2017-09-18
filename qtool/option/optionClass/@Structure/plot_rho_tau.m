function [ hfig ] = plot_rho_tau( self )
%PLOT_RHO_TAU ��rho~tau��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% ��ͼ

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).tau = tau;
    end
end

copy.calcRho();

plot( tau , copy.rho);

%%%%%%%%%%%%%%����������������
xlabel('\tau')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%   

grid on;
txt = '��Ȩ���Structure��rho��\tau�ĺ���ͼ';

title(txt)

hold off


end

