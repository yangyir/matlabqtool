function [ output_args ] = monitor_kuaqi( obj, pxtype )
% 输出一个表格，看一眼，为交易做辅助
% 输出形同：
% S = 2.0680  |  09-Mar-2016 13:48:42
% optName	askpx	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2200]	134	32.1%	 38.7	 77.5	 4.3	 17.1	 -12.6	 11.3
% [沽3月1950]	158	35.3%	 -38.9	 -77.8	 3.9	 15.6	 -12.7	 11.3
% [  合 计 ]	292	67.4%	 -0.1	 -0.3	 8.2	 32.7	 -25.3	 22.6
% 时间已过 0.031427 秒。
% S = 2.0680  |  09-Mar-2016 13:48:42
% optName	bidpx	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2200]	132	31.9%	 38.5	 76.9	 4.3	 17.1	 -12.4	 11.2
% [沽3月1950]	153	34.9%	 -38.3	 -76.6	 3.9	 15.6	 -12.5	 11.2
% [  合 计 ]	285	66.8%	 0.1	 0.3	 8.2	 32.8	 -24.9	 22.4
% 
% ----------------
% 程刚，20160309
% cg, 20160311, 把两个print_ask(), print_bid() 写出去了
% cg, 20160320, 把S改成用quoteS来取

optFar = obj.optFar;
optNear = obj.optNear;

% 取行情
% 用H5行情更新，需要init时启动H5行情
% 行情更新不太及时，好久取不到
while 1
    optFar.fillQuote;
    optNear.fillQuote;
    if optFar.askQ1>0 && optNear.askQ1>0
        break;
    else
        disp('期权行情未接到');
        pause(1);
    end
end
[p, mat] = getCurrentPrice('510050', '1');
S = p(1);
% S = obj.quoteS.last;
obj.S = S;
optFar.S = S;
optNear.S = S;

optFar.calc_intrinsicValue_timeValue;
optFar.calcImpvol_ask;
optFar.calc_ask_all_greeks;
optFar.calc_bid_all_greeks;

optNear.calc_ask_all_greeks;
optNear.calc_bid_all_greeks;


if ~exist('px_type', 'var'), px_type = 'both'; end

switch px_type
    case {'bid'}
        print_bid( S, optFar, optNear );
        
    case {'ask'}
        print_ask( S, optFar, optNear );
        
    case {'both', 'ask_bid', 'askbid'}
        print_ask( S, optFar, optNear );
        print_bid( S, optFar, optNear );               
end

end


function [sss] = print_ask( S, optFar, optNear )
% 做计算
%                     tic
optFar.calc_ask_all_greeks;
optNear.calc_ask_all_greeks;
%                     toc


% 输出， 形同：
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [沽3月1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.4f  |  %s\n', S, datestr(now));
fprintf('optName\taskpx\taskQ\tiv\t1%% 2%%delta\t1%% 2%%gamma\tDtheta\t1%%vega\n');
%             sss = 0;

for i = 1:2
    tmp = optFar;
    if i == 2, tmp = optNear; end
    on      = tmp.optName(6:end);
    px      = tmp.askP1 * tmp.multiplier;
    q       = tmp.askQ1;
    iv      = tmp.askimpvol*100;
    delta   = tmp.askdelta * tmp.multiplier * S*0.01;
    delta2  = tmp.askdelta * tmp.multiplier * S*0.02;
    gamma1  = tmp.askgamma * tmp.multiplier * S*S*0.0001/2 ;
    gamma2  = tmp.askgamma * tmp.multiplier * S*S*0.0004/2 ;
    theta   = tmp.asktheta * tmp.multiplier / 365 ;
    vega    = tmp.askvega * tmp.multiplier * 0.01;
    
    sss(i,:) = [px, q, iv, delta, delta2, gamma1, gamma2, theta, vega];
    
    fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', on,...
        px, q, iv, delta, delta2,  gamma1, gamma2, theta, vega);
end

ttl = sss(1,:) - sss(2,:);
ttl(:, 2) = min(sss(:,2));
fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', '  跨  期 ',...
    ttl);
end

function [sss] = print_bid( S, optFar, optNear )
% 做计算
%         tic
optFar.calc_bid_all_greeks;
optNear.calc_bid_all_greeks;
%         toc


% 输出， 形同：
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [沽3月1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.4f  |  %s\n', S, datestr(now));
fprintf('optName\tbidpx\tbidQ\tiv\t1%% 2%%delta\t1%% 2%%gamma\tDtheta\t1%%vega\n');
%             sss = 0;

for i = 1:2
    tmp = optFar;
    if i == 2, tmp = optNear; end
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

ttl = sss(1,:) - sss(2,:);
ttl(:, 2) = min(sss(:,2));
fprintf('[%s]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', '  跨  期 ',...
    ttl);

end


