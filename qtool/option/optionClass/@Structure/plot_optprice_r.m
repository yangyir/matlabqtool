function [ hfig ] = plot_optprice_r( self )
%PLOT_OPTPRICE_R ����Ȩ�۸��R��ͼ
% ----------------------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy  = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ����px~r��ͼ

% ������������:r��S��sigma���ᱻ���и���
r = 0.005:0.005:0.095;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).r = r;
    end
end

copy.calcPx();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( r , copy.px );

grid on
txt = 'Structure��Ȩ��ϵļ۸��r�ĺ���ͼ';

xlabel('r')
ylabel( '�۸�/��ֵ' )

title(txt)

hold off

end

