function monitor_iv_vega_theta(obj, px_type)
% ���һ����񣬿�һ�ۣ�Ϊ����������
% �����ͬ��
% S = 2.0680  |  09-Mar-2016 13:48:42
% optName	askpx	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2200]	134	32.1%	 38.7	 77.5	 4.3	 17.1	 -12.6	 11.3
% [��3��1950]	158	35.3%	 -38.9	 -77.8	 3.9	 15.6	 -12.7	 11.3
% [  �� �� ]	292	67.4%	 -0.1	 -0.3	 8.2	 32.7	 -25.3	 22.6
% ʱ���ѹ� 0.031427 �롣
% S = 2.0680  |  09-Mar-2016 13:48:42
% optName	bidpx	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2200]	132	31.9%	 38.5	 76.9	 4.3	 17.1	 -12.4	 11.2
% [��3��1950]	153	34.9%	 -38.3	 -76.6	 3.9	 15.6	 -12.5	 11.2
% [  �� �� ]	285	66.8%	 0.1	 0.3	 8.2	 32.8	 -24.9	 22.4
% 
% ----------------
% �̸գ�20160309
% cg, 20160311, ������print_ask(), print_bid() д��ȥ��
% cg, 20160320, ��S�ĳ���quoteS��ȡ
% cg, 20160922, ���print_opt, ͳһprint_ask(), print_bid()��ɾȥ2%delta��2%gamma���
% cg, 20170510, �����ʾtmV

%%
call = obj.call;
put = obj.put;

% ȡ����
% ��H5������£���Ҫinitʱ����H5����
% ������²�̫��ʱ���þ�ȡ����
while 1
    call.fillQuote;
    put.fillQuote;
    if call.askQ1>0 && put.askQ1>0
        break;
    else
        disp('��Ȩ����δ�ӵ�');
        pause(1);
    end
end
S = call.S;

call.calc_intrinsicValue_timeValue;
call.calcImpvol_ask;
% call.calc_ask_all_greeks;
% call.calc_bid_all_greeks;
% 
% put.calc_ask_all_greeks;
% put.calc_bid_all_greeks;

%% ���
if ~exist('px_type', 'var'), px_type = 'both'; end

switch px_type
    case {'bid'}
        print_opt( S, call, put, 'bid');
        
    case {'ask'}
        print_opt( S, call, put, 'ask');
       
        
    case {'both', 'ask_bid', 'askbid'}
        print_opt( S, call, put, 'ask');
        print_opt( S, call, put, 'bid');
end

end

%{
�������ɺ��������3���º�û���쳣����ɾ���� ����20170510

function [sss] = print_ask( S, call, put )
% ������
%                     tic
call.calc_ask_all_greeks;
put.calc_ask_all_greeks;
%                     toc


% ����� ��ͬ��
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [��3��1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.4f  |  %s\n', S, datestr(now));
fprintf('optName\taskP\taskQ\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\n');
%             sss = 0;

for i = 1:2
    tmp = call;
    if i == 2, tmp = put; end
    on      = tmp.optName(6:end);
    px      = tmp.askP1 * tmp.multiplier;
    q       = tmp.askQ1;
    iv      = tmp.askimpvol*100;
    delta   = tmp.askdelta * tmp.multiplier * S*0.01;
%     delta2  = tmp.askdelta * tmp.multiplier * S*0.02;
    gamma1  = tmp.askgamma * tmp.multiplier * S*S*0.0001/2 ;
%     gamma2  = tmp.askgamma * tmp.multiplier * S*S*0.0004/2 ;
    theta   = tmp.asktheta * tmp.multiplier / 365 ;
    vega    = tmp.askvega * tmp.multiplier * 0.01;
    inV     = tmp.calcIntrinsicValue * tmp.multiplier;
    tmV     = px - inV;

%     sss(i,:) = [px, q, iv, delta, delta2, gamma1, gamma2, theta, vega];
%     
%     fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', on,...
%         px, q, iv, delta, delta2,  gamma1, gamma2, theta, vega);
  
    sss(i,:) = [px, q, iv, delta,  gamma1,  theta, vega, tmV];
    
    fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\n', on,...
        px, q, iv, delta, gamma1,  theta, vega, tmV);
end

ttl = sss(1,:) + sss(2,:);
ttl(:, 2) = min(sss(:,2));
fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\n', '  �� �� ',...
    ttl);
end

function [sss] = print_bid( S, call, put )
% ������
%         tic
call.calc_bid_all_greeks;
put.calc_bid_all_greeks;
%         toc


% ����� ��ͬ��
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [��3��1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.4f  |  %s\n', S, datestr(now));
fprintf('optName\tbidP\tbidQ\tiv\t1%% 2%%delta\t1%% 2%%gamma\tDtheta\t1%%vega\n');
%             sss = 0;

for i = 1:2
    tmp = call;
    if i == 2, tmp = put; end
    on      = tmp.optName(6:end);
    px      = tmp.bidP1 * tmp.multiplier;
    q       = tmp.bidQ1;
    iv      = tmp.bidimpvol*100;
    delta   = tmp.biddelta * tmp.multiplier * S*0.01;
    delta2  = tmp.biddelta * tmp.multiplier * S*0.02;
    gamma1  = tmp.bidgamma * tmp.multiplier * S*S*0.0001/2 ;
    gamma2  = tmp.bidgamma * tmp.multiplier * S*S*0.0004/2 ;
    theta   = tmp.bidtheta * tmp.multiplier / 365 ;
    vega    = tmp.bidvega * tmp.multiplier * 0.01;
    
    sss(i,:) = [px, q, iv, delta, delta2, gamma1, gamma2, theta, vega];
    
    fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', on,...
        px, q, iv, delta, delta2,  gamma1, gamma2, theta, vega);
end

ttl = sss(1,:) + sss(2,:);
ttl(:, 2) = min(sss(:,2));
fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', '  �� �� ',...
    ttl);

end

%}

function [sss] = print_opt( S, call, put, askbid_flag )
%%
if ~exist('askbid_flag', 'var')
    askbid_flag = 'ask';
end

%% ������
% ����greeks��ʱ�ܶ࣬0.04s���ң�Ӧ����c++
% tic
switch askbid_flag
    case{'ask'}
        call.calc_ask_all_greeks;
        put.calc_ask_all_greeks;
        call.calcIntrinsicValue;
        put.calcIntrinsicValue;
    case{'bid'}        
        call.calc_bid_all_greeks;
        put.calc_bid_all_greeks;
end
% toc


%% ����� ��ͬ��
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [��3��1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.3f  |  %s\n', S, datestr(now));
switch askbid_flag
    case{'ask'}
        fprintf('optName\taskP\taskQ\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\ttimeV\n');
    case{'bid'}
        fprintf('optName\tbidP\tbidQ\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\ttimeV\n');
end

for i = 1:2
    tmp = call;
    if i == 2, tmp = put; end
    switch askbid_flag
        case{'ask'}
            on      = tmp.optName(6:end);
            px      = tmp.askP1 * tmp.multiplier;
            q       = tmp.askQ1;
            iv      = tmp.askimpvol*100;
            delta   = tmp.askdelta * tmp.multiplier * S*0.01;
            %     delta2  = tmp.askdelta * tmp.multiplier * S*0.02;
            gamma   = tmp.askgamma * tmp.multiplier * S*S*0.0001/2 ;
            %     gamma2  = tmp.askgamma * tmp.multiplier * S*S*0.0004/2 ;
            theta   = tmp.asktheta * tmp.multiplier / 365 ;
            vega    = tmp.askvega * tmp.multiplier * 0.01;
            tmV     = px - tmp.intrinsicValue * tmp.multiplier;
            
        case{'bid'}
            on      = tmp.optName(6:end);
            px      = tmp.bidP1 * tmp.multiplier;
            q       = tmp.bidQ1;
            iv      = tmp.bidimpvol*100;
            delta   = tmp.biddelta * tmp.multiplier * S*0.01;
%             delta2  = tmp.biddelta * tmp.multiplier * S*0.02;
            gamma   = tmp.bidgamma * tmp.multiplier * S*S*0.0001/2 ;
%             gamma2  = tmp.bidgamma * tmp.multiplier * S*S*0.0004/2 ;
            theta   = tmp.bidtheta * tmp.multiplier / 365 ;
            vega    = tmp.bidvega * tmp.multiplier * 0.01;
            tmV     = px - tmp.intrinsicValue * tmp.multiplier;

            
    end
            

%     sss(i,:) = [px, q, iv, delta, delta2, gamma1, gamma2, theta, vega];
%     
%     fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', on,...
%         px, q, iv, delta, delta2,  gamma1, gamma2, theta, vega);
  
    sss(i,:) = [px, q, iv, delta,  gamma,  theta, vega, tmV];
    
    fprintf('[%s]\t%0.0f\t%2.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\n', on,...
        px, q, iv, delta, gamma,  theta, vega, tmV);
end

ttl = sss(1,:) + sss(2,:);
ttl(:, 2) = min(sss(:,2));
fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\n', '  �� �� ',...
    ttl);
end
