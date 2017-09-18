function [ hfig ] = plot_px_vega_sigma( self )
%PLOT_PX_VEGA_SIGMA ��px_vega~sigma��ͼ
% ---------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ

volsurf = 0.10:0.05:1;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).sigma = volsurf;
    end
end

copy.calcPx();
copy.calcVega();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% px~sigma
subplot(211)
plot( volsurf , copy.px );
grid on
txt = '��Ȩ���Structure�۸��sigma�ĺ���ͼ';
title(txt)
xlabel('sigma')
ylabel('px')

% vega~sigma
subplot(212)
plot( volsurf , copy.vega );
grid on
txt = '��Ȩ���Structure��vega��sigma�ĺ���ͼ';
title(txt)
xlabel('sigma')
ylabel('vega')

hold off

end

