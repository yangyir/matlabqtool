function [ hfig ] = plot_gamma_K( self , K )
%PLOT_GAMMA_K ��gamma~K��ͼ
% ---------------------
% ���Ʒ壬201601230
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
        copy.optPricers( j , i ).K = K;
    end
end

copy.calcGamma();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( K, copy.gamma );
legend('gamma');

%%%%%%%%%%%%%%����������������
xlabel('K')
ylabel('gamma')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = 'Structure��Ȩ���gamma��K�ĺ���ͼ';

title(txt)

hold off

end

