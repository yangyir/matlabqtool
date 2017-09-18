function [ hfig ] = plot_optprice_sigma( self )
%PLOT_OPTPRICE_SIGMA ����Ȩ�۸��sigma��ͼ
% ----------------------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% ��ͼ����px~sgima��ͼ obj.sigma*100

volsurf = 0.10:0.05:1;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).sigma = volsurf;
    end
end

copy.calcPx();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( volsurf , copy.px );

xlabel('sigma')
ylabel('px') 
grid on

txt = '��Ȩ���Structure�۸��sigma�ĺ���ͼ';

title(txt)

hold off

end

