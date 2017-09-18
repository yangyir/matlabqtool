%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为计算指数IndexCode起始日BeginDate和截止日EndDate之间收益率。
% 输入参数：SecCode（string），指数代码；
%          BeginDate（date），起始日期；
%          EndDate（date），截止日期；
% 输出参数： output（float），指数收益率
% 例： output = F_ANALYSIS_INDEXRETURN('000300.SHI','2012-03-01','2012-05-06')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output = F_ANALYSIS_INDEXRETURN(IndexCode,BeginDate,EndDate)


output = fetch ('F_ANALYSIS_INDEXRETURN',IndexCode,BeginDate,EndDate);

output = cell2mat(output);
end
