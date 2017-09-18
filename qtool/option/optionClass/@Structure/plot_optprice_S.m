function [ hfig ] = plot_optprice_S( self, S_values  )
%PLOT_OPTPRICE_S ����Ȩ�۸��S��ͼ
% S_values������㣬Ĭ��ֵ1.8:0.05:2.7 �������е�K��
% ----------------------------------
% ���Ʒ壬20160130
% �̸գ�20160211�������������S_values
% ���Ʒ壬20160316������copy���������о�

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% ��ͼ����px~S��ͼ����payoff
% ����SĬ��ֵ��
if ~exist( 'S_values' , 'var' )
    center = self.S;
    if center == 0 || isempty(center) || isnan(center)
        center = 2.2;
    end
    mn = max( center * 0.8, 1.8);
    mx = min( center * 1.2, 2.8);
    S_values  = [0:19] * (mx-mn)/20 + mn;
end;

% if ~exist('S_values', 'var')
%     S_values = 1.8:0.05:2.7;
% end

% ����ǻ���������Ҫ����
S = S_values;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end
copy.calcPx();

ST = S_values;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).ST = ST;
    end
end

copy.payoff = 0;
[ L1, L2 ] = size( copy.optPricers );
for j = 1:L1
    for i = 1:L2
        oi           = copy.optPricers(j,i);
        nums         = copy.num(j,i);
        copy.payoff  = copy.payoff + nums * oi.calcPayoff( ST );
    end
end 

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( S , copy.px );
hold on
plot( ST , copy.payoff , 'k' );
legend('��Ȩ���Structure����', '����payoff');
grid on
txt = 'Structure��Ȩ��ϼ۸��S�ĺ���ͼ';

xlabel('S')
ylabel('�۸�/��ֵ')

title(txt)

hold off


end

