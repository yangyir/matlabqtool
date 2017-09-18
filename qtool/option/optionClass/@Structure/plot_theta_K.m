function [ hfig ] = plot_theta_K( self , K )
%PLOT_THETA_K ��theta~K��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).K = K;
    end
end

copy.calcTheta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot(  K, copy.theta );
legend('theta');

%%%%%%%%%%%%%%����������������
xlabel('K')
ylabel('theta')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩ���Structure��theta��K�ĺ���ͼ';

title(txt)

hold off

end

