function [ hfig ] = plot_theta_S( pricer , S )
%PLOT_THETA_S ��theta~S��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

% ����SĬ��ֵ��
if ~exist( 'S' , 'var' )
    center = pricer.S;
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

%% ��ͼ
% ����
copy.S = S;
copy.calcTheta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( copy.S, copy.theta);
legend('theta');

xlabel('S')
ylabel('theta')

grid on;
txt = 'theta';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% �ӻ���ǰ��
hold on
pricer.calcTheta();
plot( pricer.S, pricer.theta, 'or');



end
