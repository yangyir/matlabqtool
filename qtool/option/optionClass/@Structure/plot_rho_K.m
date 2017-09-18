function [ hfig ] = plot_rho_K( self , K )
%PLOT_RHO_K ��rho~K��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%%

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).K = K;
    end
end

copy.calcRho();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( K, copy.rho );
legend('rho');

%%%%%%%%%%%%%%����������������
xlabel('K')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩ���Structure��rho��K�ĺ���ͼ';

title(txt)

hold off

end

