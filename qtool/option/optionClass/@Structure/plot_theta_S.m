function [ hfig ] = plot_theta_S( self , S )
%PLOT_THETA_S ��theta~S��ͼ
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
        copy.optPricers(j,i).S = S;
    end
end

copy.calcTheta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( S, copy.theta );
legend('theta');
%%%%%%%%%%%%%%����������������
xlabel('S')
ylabel('theta')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '��Ȩ���Structure��theta��S�ĺ���ͼ';

title(txt)

hold off


end
