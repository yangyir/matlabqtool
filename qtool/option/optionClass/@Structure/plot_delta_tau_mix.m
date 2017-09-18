function [ hfig ] = plot_delta_tau_mix( self )
%PLOT_DELTA_TAU ��delta~tau��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

K   = [1.8,2.3,2.7];
tau = 0.01:0.02:0.5;

colorheader = 'rgb';

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

hold on

for m = 1 : 3
    
    for j = 1:L1
        for i = 1:L2
            copy.optPricers( j , i ).K   = K(m);
            copy.optPricers( j , i ).tau = tau;
        end
    end
    
    copy.calcDelta();
    
    plot( tau , copy.delta , colorheader(m) );
    
    copy.delta = [];
end

legend('K=1.8','K=2.3','K=2.7')
    
%%%%%%%%%%%%%%����������������

xlabel('\tau')
ylabel('delta')

%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = 'Structure��Ȩ���delta��\tau�ĺ���ͼ';

title(txt)

hold off

end

