function [ obj ] = readCSV_cleanL2_Tonglian( obj, filename )
%READCSV_CLEAN_TONGLIAN 读取通联L2干净数据， 市场快照，MarketData
% ----------------------------
% 程刚，201608

%% 预处理

if ~exist('filename', 'var')
    filename = 'D:\level2\clean\20140725\SH600000\MarketData.csv';
end



%% main
data = csvread(filename);
% [T, L] = size(data);


%%
obj.levels = 10;
obj.type = 'stock';

obj.code  = data(1,2);
obj.date2  = num2str( data(1,3) );
obj.date = datenum(obj.date2, 'yyyymmdd');

% 


obj.time2  = data(:,4);

intT = obj.time2 ; 
HH = floor(intT/10000000) ;
M = rem(intT,10000000) ; 
MM = floor(M/100000) ; 
S = rem(M ,100000 ) ;
SS = floor(S/1000) ; 
obj.time =  obj.date + HH/24 + MM/60/24 + SS/60/60/24 ; 
% 
% obj.preclose = data(:, 5); % 错
% obj.open  = data(:,6);
% obj.high  = data(:,7);
% obj.low   = data(:,8);
% obj.close = data(:,9);
% 
obj.last  = data(:,9);   % close / last
obj.preSettlement = data(1,10);% preClose
obj.tranCnt = data(:,11);
obj.volume = data(:,12);
obj.amount = data(:,13);
 
% obj.timeEnd = data(:,54);
% obj.no  = data(:,55);

%% 挂单数据
obj.askP = data(:, 14:2:33);
obj.askQ = data(:, 15:2:33);
obj.bidP = data(:, 34:2:53);
obj.bidQ = data(:, 35:2:54);
% 算额
obj.askA = obj.askP .* obj.askQ;
obj.bidA = obj.bidP .* obj.bidQ;


%%  画一些看看，正式函数没有
figoff = 1;
if figoff
    return;
end


figure(630); hold off;
plot(c.askP(:,1));
hold on;
plot(c.bidP(:,1) );end

