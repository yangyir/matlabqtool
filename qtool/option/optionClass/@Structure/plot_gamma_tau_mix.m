function [ hfig ] = plot_gamma_tau_mix( self )
%PLOT_GAMMA_TAU ��gamma~tau��ͼ
% ����״̬��һ���
% ---------------------
% ���Ʒ壬20160129

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%%

S = [1.8,2.3,2.7];

colorheader = 'rgb';
% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end
hold on

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

for m = 1:3
    for j = 1:L1
        for i = 1:L2
            copy.optPricers( j , i ).S = S(m);
        end
    end
    copy.calcGamma();
    plot( tau, copy.gamma,colorheader(m));
end

legend('S=1.8','S=2.3','S=2.7')

xlabel('\tau')
ylabel('gamma')

grid on;
txt = 'Structure��Ȩ���gamma��\tau�ĺ���ͼ';

title(txt)

hold off

end

