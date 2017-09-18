%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于下载指定证券代码（多个请用‘，’隔开）相应指定起始和截止日期之间的日
% 行情数据，保存到backtest Cache中，文件名为证券代码。
% 这里的日行情数据格式如下：
% 732686	4.460868254	4.48874868	4.419047614	4.453898147	11022101	6.39	215.9386515
% 732687	4.426017721	4.432987827	4.286615588	4.377226974	21426743	6.28	212.2213977
% 732688	4.377226974	4.426017721	4.321466121	4.342376441	9749282     6.23	210.5317369
% 732689	4.328436228	4.377226974	4.314496014	4.377226974	6720529     6.28	212.2213977
% 732690	4.356316654	4.426017721	4.307525908	4.328436228	7996673     6.21	209.8558726
% 日期       前复权开盘   前复权最高   前复权最低   前复权收盘   成交量   不复权收盘  后复权收盘

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tool_download_callback(Path_backtest)

%  获取证券代码
prompt = {'证券代码（多个请用‘，’隔开）：','StartDate','EndDate'};
dlg_title = '输入下载证券代码';
def ={'000300.SHI,000001.SHI','2012-01-01','2012-06-01'};
num_lines = 1;
options.Resize = 'on';

input_arg = inputdlg(prompt,dlg_title,num_lines,def,options);
if ~isempty(input_arg)
    StartDate = input_arg{2};
    EndDate = input_arg{3};
    s = input_arg{1};
    
    token = cell(1,1);
    index = 1;
    [token{index}, remain] = strtok(s,',');
    %  下载指定证券代码日行情数据并保存到Cache中
    writeintocache_backtest(token{index},StartDate,EndDate,Path_backtest);
    while ~isempty(remain)
        s =  remain;
        index = index + 1;
        [token{index}, remain] = strtok(s,',');
         writeintocache_backtest(token{index},StartDate,EndDate,Path_backtest);
    end
end


end