function [  ] = cleasing_emptyPQ( obj, tickvalue )
%CLEASING_EMPTYPQ 数据清洗：报价档位有空时，填充进去值
% 典型情况：集合竞价时，1档以外都没有
% 典型情况：挂单深度不够时，5档/10档以内挂不满
% 典型情况：涨跌停时
% 典型情况：一个天量市价单连吃若干档，价格急剧变动
% -----------------------------------
% 程刚，201609


%% 
if ~exist('tickvalue', 'var')
    tickvalue = 0.01;
end

%% 简单粗暴版本
% 量都填0
% 用iT-1填1档
% 用低档填高档


%% 先把挂单量都置零
obj.askQ(obj.askP==0) = 0;
obj.bidQ(obj.bidP==0) = 0;



%% 1档的处理：用前挂单填
if obj.askP(1,1) == 0 , obj.askP(1,1) = obj.preSettlement;end
if obj.bidP(1,1) == 0, obj.bidP(1,1) = obj.preSettlement - 0.01; end

idx  = find(obj.askP(:,1)==0);
for id = 1:length(idx)   
    i = idx(id);
    if obj.bidP(i, 1) >0   % 如有bidP，则+1
        obj.askP(i,1) = obj.bidP(i,1) + tickvalue;
    else
        obj.askP(i, 1) = obj.askP(i-1,1);
    end
end

idx  = find(obj.bidP(:,1)==0);
for id = 1:length(idx)
    i = idx(id);
    if obj.askP(i, 1) >0  % 如有askP，则-1 
        obj.bidP(i,1) = obj.askP(i,1) - tickvalue;
    else
        obj.bidP(i, 1) = obj.bidP(i-1,1);
    end
end

    
%% 2-10档的处理   

LEVEL = size(obj.askP, 2);

for iLV = 2:LEVEL
    idx = obj.askP(:,iLV)==0;
    obj.askP(idx,iLV) = obj.askP(idx,iLV - 1) + tickvalue;
    
    idx = obj.bidP(:,iLV)==0;
    obj.bidP(idx,iLV) = obj.bidP(idx,iLV - 1) - tickvalue;
end
         
         

%%  作图, debug用
plot_flag = 0 ;
if plot_flag == 0
    return;
end

figure(201); hold off
plot(obj.askP(:,1)); hold on
plot(obj.bidP(:,1),'r')

figure(202); hold off
plot(obj.askP(:,1) - obj.bidP(:,1))

figure(211); hold off
plot(obj.askP(:,2));hold on
plot(obj.bidP(:,2), 'r') ; 


figure(212); hold off
plot( obj.askP(:, LEVEL)); hold on;
plot( obj.bidP(:, LEVEL), 'r')
    
end

