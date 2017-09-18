function [ obj ] = updateBid( obj, origin )
%UPDATEbid 把origin中的非0，非nan，与obj不同的域的值价注入obj
% 程刚，151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%% 更新L2数据
flds = {
       'quoteTime';%     行情时间(s)
       'dataStatus';%    DataStatus	
       'secCode';%证券代码	
       'accDeltaFlag';%全量(1)/增量(2)	
       'preSettle';%昨日结算价	
       'settle';%今日结算价	
       'open';%开盘价	
       'high';%最高价	
       'low';%最低价	
       'last';%最新价	
       'close';%收盘价	
       'refP';%动态参考价格	
       'virQ';%虚拟匹配数量	
       'openInt';%当前合约未平仓数	

       'askQ1';%申卖量1	
       'askP1';%申卖价1	
       'askQ2';%申卖量2	
       'askP2';%申卖价2	
       'askQ3';%申卖量3	
       'askP3';%申卖价3	
       'askQ4';%申卖量4	
       'askP4';%申卖价4	
       'askQ5';%申卖量5	
       'askP5';%申卖价5	
       'bidQ1';%申卖量1	
       'bidP1';%申卖价1	
       'bidQ2';%申卖量2	
       'bidP2';%申卖价2	
       'bidQ3';%申卖量3	
       'bidP3';%申卖价3	
       'bidQ4';%申卖量4	
       'bidP4';%申卖价4	
       'bidQ5';%申卖量5	
       'bidP5';%申卖价5
       
       'volume';%成交数量
       'amount';%成交金额	
       'rtflag';%产品实时阶段标志	
       'mktTime';%市场时间(0.01s)
        };

% flds    = fields( obj );
for i = 1:length(flds)
    fd  = flds{i};
    
    tmp = origin.(fd);
    
    % 如果为空、是0、没变化，跳出
    if isnan(tmp),  continue, end;
    if isempty(tmp), continue, end;
    if tmp == 0, continue,  end;
    try 
        if obj.(fd) == tmp
            continue, 
        end;
    catch
        if strcmp(obj.(fd), tmp) 
            continue;
        end
    end
    
    % 更新
    obj.(fd) = tmp;
    
    % 记录更新域
    if i == 1, continue, end;
    obj.changedL2fields{end+1} = fd;
end    

% 记录下来改变的域
obj.changedL2fields = unique(obj.changedL2fields);


end

