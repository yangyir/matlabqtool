function [ hfig ] = plot_gamma_S( self , S )
%PLOT_GAMMA_S ��gamma~S��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

% ����SĬ��ֵ��
if ~exist( 'S' , 'var' )
    center = copy.optPricers(1,1).S;
    try
        wrong =  center == 0 || isempty(center) || isnan(center);
        if wrong,  center = pricer.K; end    
    catch e
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end

copy.calcGamma();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( S , copy.gamma );
legend('gamma');

%%%%%%%%%%%%%%����������������

xlabel('S')
ylabel('gamma')

%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = 'Structure��Ȩ���gamma��S�ĺ���ͼ';

title( txt )

hold off

end