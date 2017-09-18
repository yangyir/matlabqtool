function [ hfig ] = plot_px_delta_gamma_S( pricer , S )
%PLOT_PX_DELTA_GAMMA_S ��px_delta_gamma~S��ͼ
% ---------------------
% �̸գ�20160124
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

%% ����

copy.S = S;

copy.calcPx();
copy.calcDelta();
copy.calcGamma();

hfig = figure;

%% ��ͼ��px~S
subplot(311)
plot( copy.S, copy.px);
grid on
txt = '��Ȩ�۸��S�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100,...
    datestr(copy.currentDate));
title(txt)
xlabel('S')
legend('px')

% �ӻ���ǰ��
hold on
pricer.calcPx();
plot( pricer.S, pricer.px, 'or');

%% ��ͼ��delta~S
subplot(312)
plot( copy.S, copy.delta);
grid on
xlabel('S')
legend('delta');

% �ӻ���ǰ��
hold on
pricer.calcDelta();
plot( pricer.S, pricer.delta, 'or');


%% ��ͼ��gamma~S
subplot(313)
plot( copy.S, copy.gamma );
legend('gamma');
grid on

% �ӻ���ǰ��
hold on
pricer.calcGamma();
plot( pricer.S, pricer.gamma, 'or');

end

