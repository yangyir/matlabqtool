function [ hfig ] = plot_px_theta_tau( self )
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

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

copy.calcPx();
copy.calcTheta();

tau = copy.optPricers(1,1).tau;

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% px~S
subplot(211)
plot( tau , copy.px );
grid on
txt = '��Ȩ���Structure�۸��\tau�ĺ���ͼ';
title(txt)
xlabel('\tau')
ylabel('px')

% delta~S
subplot(212)
txt = '��Ȩ���Structure��theta��\tau�ĺ���ͼ';
plot( tau, copy.theta );
grid on
title(txt)
xlabel('\tau')
ylabel('theta')

hold off

end

