function      [N, X, R, cumR] = localHist(obj, stk, etk, type, grids)
%LOCALHIST 画stk:etk局部的Histogram，若有输出就不画图（类似hist）
% 格式： [N, X, R, cumR] = localHist(obj, stk, etk, type, grids)
% 输入：
%     stk, etk    起始、终止tick号
%     type        数据类型，'last'(默认）,'bid','ask'
%     grids       分格划分， 默认为 min : tickValue : max
% 输出：
%     N           个数
%     X           划分
%     R           比例，全部为1
%     cumR        累积比例，X从小到大
% 如果没有输出，就画图，横着画barh(X, R)
% 程刚；140802

%% 前处理
len = length(obj.time);

if ~exist('stk', 'var'), stk = 1; end
if ~exist('etk', 'var')
    if obj.latest > 1
        etk = obj.latest;
    else
        etk = len;
    end
end  

stk     = max(stk,1);
etk     = min(etk,len);

% type
if ~exist('type', 'var'), type = 'last'; end
switch type
    case{'last'}
        px = obj.last(stk:etk);
    case{'bid'}
        px = obj.bidP(stk:etk,1);
    case{'ask'}
        px = obj.askP(stk:etk,1);
    otherwise
        fprintf('数据类型有错，type=%s', type);
        return;
end
       

% grids
if ~exist('grids', 'var')
    mx = max(px);
    mn = min(px);
    step = abs(diff(px));
    step = min( step(step>0) );
    grids = (mn-2*step) : step : (mx+2*step);
end
    



%% main
% try
    [N, X ] = hist(px, grids);    
    
    % 截断N，X
    l = max( find(N>0, 1, 'first') -1,    1 ) ;
    u = min( find(N>0, 1, 'last' ) +1, length(N)  );
    N = N(l:u);
    X = X(l:u);        
    
    R       = N/sum(N);
    cumR    = cumsum(R);
    
    %% 画图——如果没有输出变量
    if nargout == 0    
        barh(X, R);
        title(sprintf('local histogram: %s, tk=%d:%d', type, stk, etk));
    end
    
% catch e
%     fprintf('出错：%s\n', e.message);
%     return;
% end
end

