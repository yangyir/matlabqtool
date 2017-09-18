function [ hfig ] = plot_optprice_S( pricer , S  )
%PLOT_OPTPRICE_S ����Ȩ�۸��S��ͼ
% ----------------------------------
% �̸գ�20160124
% ���Ʒ壬20160129��������obj.sigma���ȴ���1�����
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���


%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy = pricer.getCopy();


% ����SĬ��ֵ��
if ~exist( 'S' , 'var' )
    center = pricer.S;
    if center == 0 || isempty(center) || isnan(center)
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

%% ��ͼ����px~S��ͼ����payoff
copy.S = S;
copy.calcPx();

copy.ST = S;
copy.calcPayoff();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( copy.S, copy.px );
hold on
plot( copy.ST, copy.payoff, 'k');
legend('��Ȩ����', '����payoff');
grid on
txt = '��Ȩ�۸��S�ĺ���ͼ';

% sigma���ݵĳ���
sigmaL = length( copy.sigma );

if sigmaL == 1
%     txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
%         copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, datestr(copy.currentDate));   
    txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
        pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
elseif sigmaL > 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K, datestr(copy.currentDate));
end 

title(txt)



% �ӻ���ǰ��
hold on
pricer.calcPx();
plot( pricer.S, pricer.px, 'or');
end

