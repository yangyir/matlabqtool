% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数用于将起始日与截止日之间交易日或者自然日按照步长切成小区间。返回区间起始日序
% 列和截止日序列
% 输入参数：BeginDate（date），起始日期；
%          EndDate（date），截止日期；
%          Step（int），步长，可供选项：1-日；2-周；3-月；4-季；5-半年；6-年；
%          Style（int），序列样式，可供选项：1-自然日；2-交易日；
% 输出参数： Tradingdate_b（cell），区间起始日序列
%           Tradingdate_e（cell），区间截止日序列
% 例： [Tradingdate_b,Tradingdate_e] = cutintointerval('2012-03-01','2012-05-06',1,1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function  [Tradingdate_b,Tradingdate_e] = cutintointerval(BeginDate,EndDate,Step,Style)

%  向前和向后推移一个周期，补齐原来有可能不完整的起始和截止周期。后面使用convtobegin和convtoend
%  提取区间起始日序列和截止日序列时，BeginDate和EndDate无论区间是否完整都一直存在。
switch Step
    case 1
        back = 0;
    case 2
        back = 6;
    case 3
        back = 30;
    case 4
        back = 91;
    case 5
        back = 182;
    case 6
        back = 365;
    otherwise
        
end
begindate =  datestr(datenum(BeginDate)-back,29);
enddate =  datestr(datenum(EndDate)+back,29);

% 自然日和交易日选项，日期格式都是yyyy-mm-dd
switch Style
    case 1
        Tradingdate = (datenum(begindate):datenum(enddate))';
    case 2
        Tradingdate = datenum(DQ_GetDate_V('000001.SHI',begindate,enddate,0,1));
    otherwise
       
end

% 取出扩展后起始日与截止日之间所有区间的起始日序列和截止日序列
Index = convtobegin(Tradingdate,Step,Style);
Index2 = convtoend(Tradingdate,Step);

Tradingdate_b = Tradingdate(Index,:);
Tradingdate_e = Tradingdate(Index2,:);



% 将区间起始日和期间截止日匹配起来
if  isempty(Tradingdate_b) || isempty(Tradingdate_e)
    Tradingdate_b = []; 
    Tradingdate_e = [];
    return;
else
    Tradingdate_e2 = zeros(size(Tradingdate_b,1),1);
    for Index3 = 1:size(Tradingdate_b,1)
         Tradingdate_temp = Tradingdate_e( Tradingdate_e >= Tradingdate_b(Index3)) ;
         if isempty(Tradingdate_temp)
            Tradingdate_temp = nan;
         end
         Tradingdate_e2 (Index3) = Tradingdate_temp(1,1);  
    end
end  

% 将起始日前和截止日后的日期剔除
Tradingdate_b2 = Tradingdate_b(Tradingdate_b >= datenum(BeginDate) & Tradingdate_e2 <= datenum(EndDate));
Tradingdate_e = Tradingdate_e2(Tradingdate_b >= datenum(BeginDate) & Tradingdate_e2 <= datenum(EndDate));
Tradingdate_b = Tradingdate_b2;

% 类型转换
Tradingdate_b = cellstr(datestr(Tradingdate_b,29));
Tradingdate_e = cellstr(datestr(Tradingdate_e,29));

end

