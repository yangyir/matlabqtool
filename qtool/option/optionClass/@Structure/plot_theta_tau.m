function [ hfig ] = plot_theta_tau( self )
%PLOT_THETA_TAU ��theta~tau��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%%

S = [1.8,2.3,2.7];
tau = 0.01:0.02:0.5;

colorheader = 'rgb';

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

hold on

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).tau = tau;
    end
end

for m = 1:3
    for j = 1:L1
        for i = 1:L2
            copy.optPricers(j,i).S = S(m);
        end
    end
    copy.calcTheta();
    plot( tau, copy.theta,colorheader(m));
end

legend('S=1.8','S=2.3','S=2.7')
    
%%%%%%%%%%%%%%����������������
xlabel('\sim tau')
ylabel('theta')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '��Ȩ���Structure��theta��\sim tau�ĺ���ͼ';

title(txt)

hold off

end

