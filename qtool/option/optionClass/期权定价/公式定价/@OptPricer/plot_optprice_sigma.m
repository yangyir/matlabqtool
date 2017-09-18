function [ hfig ] = plot_optprice_sigma( obj  )
%PLOT_OPTPRICE_SIGMA ����Ȩ�۸��sigma��ͼ
% ----------------------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
original = obj.getCopy();

%% ��ͼ����px~sgima��ͼ obj.sigma*100

obj.sigma = 0.10:0.05:1;
obj.calcPx();

hfig = figure;
plot(obj.sigma, obj.px );

xlabel('sigma')
ylabel('px') 
grid on
txt = '��Ȩ�۸��sigma�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    obj.CP,datestr( obj.T ), obj.K ,datestr(obj.currentDate) );

title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end



end

