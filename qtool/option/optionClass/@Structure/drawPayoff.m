function  [ hfig ] = drawPayoff( obj , ST, cost )
% ��structure��payoffͼ��
% -------------------------
% ���Ʒ壬20160120
% ���㣬20160128������ cost

if ~exist( 'ST' , 'var' )
    ST = 1.7:0.05:3;  % ���е�K�ķ�Χ
end
if ~exist( 'cost' , 'var' )
    cost = 0;  % ��Ȩ��ϳɱ�
end

L = length(ST);
payoff = zeros(L,1);

for i = 1:L
    payoff(i) = obj.calcPayoff(ST(i)) - cost;
end

% TODO�����ĸ��ÿ�
hfig = figure;
plot( ST , payoff , 'r-*' , 'LineWidth' , 2 )
grid on
title( 'Structure��PayOff����' ,...
    'FontSize',13,'FontName','���Ŀ���' )
xlabel( 'ST' , ...
    'FontSize',13,'FontName','���Ŀ���' )
ylabel( 'PayOff' , ...
    'FontSize',13,'FontName','���Ŀ���' )
hold on

end
