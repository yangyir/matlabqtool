function [ hfig ] = plot_px_delta_gamma_S( self , S )
%PLOT_PX_DELTA_GAMMA_S ��px_delta_gamma~S��ͼ
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

copy.calcPx();
copy.calcDelta();
copy.calcGamma();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% px~S
subplot(311)
plot( S , copy.px );
grid on
txt = '��Ȩ���Structure��S�ĺ���ͼ';
title(txt)
xlabel('S')
ylabel('px')

% delta~S
subplot(312)
plot( S , copy.delta);
grid on
xlabel('S')
ylabel('delta')
txt = '��Ȩ���Structure��Delta��S�ĺ���ͼ';

title(txt)

% gamma~S
subplot(313)
plot( S , copy.gamma);
grid on
txt = '��Ȩ���Structure��Gamma��S�ĺ���ͼ';
xlabel('S')
ylabel('gamma')
title(txt)

hold off

end

