%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为计算起始日BeginDate和截止日EndDate之间无风险利率区间序列。
% 输入参数：BeginDate（date），起始日期；
%          EndDate（date），截止日期；
%          Step（int），步长，可供选项：1-日；2-周；3-月；4-季；5-半年；6-年；
%          Style（int），序列样式，可供选项：1-自然日；2-交易日；
%          Type（int），剔除规则，可供选项：1-不剔除；2-剔除空记录。
% 输出参数： output（cell），指数区间收益率序列
% 例： output = F_SERIES_RISKFREERETURN('2012-03-01','2012-05-06',1,1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output = F_SERIES_RISKFREERETURN(BeginDate,EndDate,Step,Style,Type)

output = fetch('F_SERIES_RISKFREERETURN',BeginDate,EndDate,Step,Style,Type);

end