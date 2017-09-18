function [ hfig ] = plot_optprice_r( pricer , r  )
%PLOT_OPTPRICE_R ����Ȩ�۸��R��ͼ
% ----------------------------------
% ��ܣ�20160124
% ���Ʒ壬20160129��������obj.sigma���ȴ���1�����
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% ���Ʒ壬20160301��ʹ��Copy�Ľ��������ͼ

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ����px~r��ͼ

if ~exist( 'r' , 'var' )
    r = 0.005:0.005:0.095;
end

copy.r = r;
copy.calcPx();

if nargout > 0
    hfig = figure;
end

plot(copy.r, copy.px);
grid on
txt = '��Ȩ�۸��r�ĺ���ͼ';

% sigma���ݵĳ���
sigmaL = length( copy.sigma );

if sigmaL == 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, datestr(copy.currentDate));
else
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K , datestr(copy.currentDate));
end


title(txt)

% ��ԭ�ȵĵ����ȥ
copy.r = pricer.r;
copy.calcPx();
hold on
plot( copy.r, copy.px , 'ro' , ...
    'MarkerFaceColor' , 'r' )


end

