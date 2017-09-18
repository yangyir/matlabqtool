function [ hfig ] = plot_delta_S( pricer , S )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% �̸գ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% ���Ʒ壬20160301��ʹ��Copy�Ľ��������ͼ
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���


%% Ԥ����
% TODO: ���Ԥ����

% ��copy��������о�
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

%% ��Copy������ͼ
% ����
copy.S = S;
copy.calcDelta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( copy.S, copy.delta);
legend('delta');

xlabel('S')
ylabel('delta')

grid on;
txt = '��Ȩdelta��S�ĺ���ͼ';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100,...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% �ӻ���ǰ��
hold on
pricer.calcDelta();
plot( pricer.S, pricer.delta, 'or');

% ���Ҫhold off
hold off

end

