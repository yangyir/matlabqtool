function [ hfig ] = plot_optprice_tau( self, tau  )
%PLOT_OPTPRICE_tau ����Ȩ�۸��tau��ͼ
% ----------------------------------
% ���Ʒ壬20160130
% ���Ʒ壬20160215������tau����T��currentDate������ģ������������������޸�
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% ��ͼ����px~tau��ͼ
if ~exist('tau', 'var')
tau = 0.01:0.02:0.5;
end


for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

px   = copy.calcPx();
tau  = copy.optPricers( 1,1 ).tau;

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot(  tau , px );

xlabel('\tau')
ylabel('px')

grid on
txt = '��Ȩ���Structure�۸�� \tau �ĺ���ͼ';

title(txt);

hold off

end

