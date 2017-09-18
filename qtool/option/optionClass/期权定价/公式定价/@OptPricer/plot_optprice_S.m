function [ hfig ] = plot_optprice_S( obj  )
%PLOT_OPTPRICE_S ����Ȩ�۸��S��ͼ
% ----------------------------------
% �̸գ�20160124
% ���Ʒ壬20160129��������obj.sigma���ȴ���1�����
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
original = obj.getCopy();

%% ��ͼ����px~S��ͼ����payoff

obj.S = 1.8:0.05:2.7;
px = obj.calcPx();

obj.ST = 1.8:0.05:2.7;
obj.calcPayoff();

hfig = figure;
plot(obj.S, obj.px);
hold on
plot(obj.ST, obj.payoff, 'k');
legend('��Ȩ����', '����payoff');
grid on
txt = '��Ȩ�۸��S�ĺ���ͼ';

% sigma���ݵĳ���
sigmaL = length( obj.sigma );

if sigmaL == 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K, obj.sigma*100, datestr(obj.currentDate));
elseif sigmaL > 1
    % ���obj.sigma���ܻ���ֳ��ȴ���1�����
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K, datestr(obj.currentDate));
end 

title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

