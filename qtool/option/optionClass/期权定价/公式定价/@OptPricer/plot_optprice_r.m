function [ hfig ] = plot_optprice_r( obj  )
%PLOT_OPTPRICE_R ����Ȩ�۸��R��ͼ
% ----------------------------------
% ��ܣ�20160124
% ���Ʒ壬20160129��������obj.sigma���ȴ���1�����
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���


%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
original = obj.getCopy();

%% ��ͼ����px~r��ͼ

obj.r = 0.005:0.005:0.095;
obj.calcPx();

hfig = figure;
plot(obj.r, obj.px);
grid on
txt = '��Ȩ�۸��r�ĺ���ͼ';

% sigma���ݵĳ���
sigmaL = length( obj.sigma );

if sigmaL == 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K, obj.sigma*100, datestr(obj.currentDate));
else
    % ���obj.sigma���ܻ���ֳ��ȴ���1�����
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K , datestr(obj.currentDate));
end


title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

