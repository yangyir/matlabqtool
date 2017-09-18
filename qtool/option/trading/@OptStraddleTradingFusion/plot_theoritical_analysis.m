function [  ] = plot_theoritical_analysis( obj, Smin, Smax )
%PLOT_THEORITICAL_ANALYSIS �˴���ʾ�йش˺�����ժҪ
% 1������һ��structure������straddle
% 2������������� px ~ S, ������
% 3��ȡʵ�ʼ۸񣬱��straddle��bid��ask
% 4�������µ������������µ��������Ҫʹ�õ�ʵ�ʽ��׵Ĳ�����
% --------------------------
% 201705, �̸գ� �������Smin��Smax

%%
% clear all;
% rehash;

if ~exist('Smin', 'var'),
    Smin = 2.1;
end

if ~exist('Smax', 'var'),
    Smax = 2.4;
end


%% ȡQuoteOpt
cquote = obj.call;
pquote = obj.put;


%% ȡ��λ



%% ����straddle structure
s = Structure;
s.volsurf = obj.volsurf;
% s.volsurf.update_VolSurface( 'h' )
% s.volsurf.plot

% [p, mat] = getCurrentPrice('510050', '1');
% s.S = p(1);

S = obj.quoteS.last;
obj.S = S;
s.S = obj.S;

% ��QuoteOptת��OptPricer���Թ����滭ͼ��
call = cquote.QuoteOpt_2_OptPricer('bid');
put  = pquote.QuoteOpt_2_OptPricer('bid');

s.optPricers(1) = put;
s.optPricers(2) = call;
s.num = [1,1];

s.inject_environment_params

% s.plot_optprice_S
% s.plot_gamma_S
% s.plot_delta_S
% s.plot_px_delta_gamma_S

%% ȡ���ۼ۸���ͼ
% call.S = s.S; call.calcPx; 
% put.S = s.S; put.calcPx;
% 
% % call.px = 0.0432;
% % put.px = 0.0562;
% cost = call.px + put.px;
% 
% 
% cost = s.calcPx;
%     
% s.plot_optprice_S(1.8:0.01:2.2)
% hold on
% plot( s.S, cost, 'ro');
% 
% % ��ֱ��
% x = 1.8:0.01:2.2;
% y = cost* ones(size(x));
% plot( x, y, 'r');


%% ��delta==0 ��S��
% tic
% [delta0_S, delta] = s.solve_delta0_S(2.1, 2.2, 0.001);
% toc
% fprintf('S0 = %f,  delta0 = %f\n', delta0_S, delta);

%% ȡʵ�ʼ۸�, ���㽻��ӯ��
figure(211); hold off;
ask = cquote.askP1 + pquote.askP1;
bid = cquote.bidP1 + pquote.bidP1;
cost= ask;

abs = ask - bid;
abs_pct = abs/bid;

% �Լ����Ļ�ͼ�ĺ��᷶Χ�;��ȣ�����1.8:0.01:2.1    
% x = 2:0.01:2.3;
x = Smin:0.01:Smax;

s.plot_optprice_S(x)
hold on
plot( s.S, cost, 'ro');

% ��ֱ��
y = cost* ones(size(x));
z = bid * ones( size(x));
plot( x, y, 'r');
plot( x, z, 'g');





%% 

end
