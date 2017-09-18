% runbacktest_cmd('MA','2010-1-1','2012-1-1','000001.SZ',20:10:50,50:10:80,100000:100000:300000)
% runbacktest_cmd('cppi','2012-2-3','2012-3-3',1000000,900000,3,{'510050.OF';'510180.OF'},'010107.SH',5)
function  runbacktest_cmd(varargin)

Path = varargin{end};
[Path,sheet] = strtok(deblank(Path));

configurefiletype = 1;

global Path_Gildata;
path_backtest_configure = strcat(Path_Gildata,'\Backtest\Configure\ConfigureBacktest.xlsx');
global Path_Gildata_Backtest;
Path_Gildata_Backtest = strcat(Path_Gildata,'\Backtest');

configure = readconfigure(path_backtest_configure,configurefiletype);
funnam = varargin{1};

argnum = nargin(funnam);
if length(varargin) < argnum+2
    error('Not enough inputs!');
elseif length(varargin) > argnum+2
    error('Too many inputs!');
end

leng = cellfun(@len,varargin);
loc = leng >1;
if any(loc)
    temp = varargin(loc);
    num = sum(loc);
    state2 = 'combinations(';
    for Index = 1:num
        if Index ~= num
            state2 = strcat(state2,'temp{',num2str(num-Index+1),'},');
        else
            state2 = strcat(state2,'temp{',num2str(num-Index+1),'}');
        end
    end
    state2 = strcat(state2,')');
    output = eval(state2);
    
    if isnumeric(output)
        output = num2cell(output);
    end
    output = fliplr(output);
else
    loc = zeros(size(varargin));
    loc(4:end-1) =1;
    output = varargin(4:end-1);
end
% 固定输出
column1 = {'参数','胜率1(盈亏)','胜率2（与大盘比）','交易次数','盈亏比','收益率','最大回撤'};

result1 = cell(size(output,1),7);
for index = 1:size(output,1)
    argument = '''(';
    for index1 = 1:size(output,2)
        if index1 ==1
            if isnumeric(output{index,index1})
                argument = strcat(argument,num2str(output{index,index1}));
            else
                argument = strcat(argument,output{index,index1});
            end
        else
            if isnumeric(output{index,index1})
                argument = strcat(argument,',',num2str(output{index,index1}));
            else
                argument = strcat(argument,',',output{index,index1});
            end
        end
    end
    argument = strcat(argument,')');
    result1(index,1) = cellstr(argument);
    
    varargin(logical(loc)) = output(index,:);
    state =  strcat(funnam,'(');
    for index2 = 2:argnum+1
        Temp = varargin{index2};
        if isnumeric(Temp)
            if index2 ~= argnum+1
                Temp = strcat('eval(''str2num(''''',num2str(Temp),''''')'')');
                state = strcat(state,Temp,',');
            else
                Temp = strcat('eval(''str2num(''''',num2str(Temp),''''')'')');
                state = strcat(state,Temp,')');
            end
        else
            if index2 ~= argnum+1
                state = strcat(state,'''',Temp,''',');
            else
                state = strcat(state,'''',Temp,''')');
            end
        end
    end
    [output1,output2,output3] = eval(state);
     disp(['已完成',num2str(index),'组参数运算，总共',num2str(size(output,1)),'组...']);
    if isempty (output1) || isempty(output2)||isempty(output3)
        disp('没有发生任何交易！')
        result1(index,2:7) = num2cell(nan(1,7));
        continue;
    end
    displaydata = calc_data_display2(output1,output2,output3,0,configure);
    result1(index,2:7) = num2cell([displaydata.winratio1,displaydata.winratio2,...
        displaydata.totaltradetime,abs(displaydata.win_averet/displaydata.lose_averet),displaydata.accumreturn,displaydata.drawdown]);
    result2(index,:) = num2cell(displaydata.interval_returns_y(:,2)');
end

result1 = [column1;result1];
%　不固定输出（分年收益率）
StartDate = datestr(output2(1,1),29);
EndDate = datestr(output2(end,1),29);
[Tradingdate_b,~] = cutintointerval(StartDate,EndDate,6,2);
if ~isempty(char(Tradingdate_b))
    column2 = cell(1,size(Tradingdate_b,1));
    for index3 = 1:size(Tradingdate_b,1)
        column2{index3} = strcat(num2str(year(Tradingdate_b(index3))),'年度收益率');
    end
    result2 = [column2;result2];
    result3 = [result1,result2];
else
    result3 = result1; 
end

arg =cell(1,sum(loc));
for index4 = 1:sum(loc)
    arg{index4} = strcat('arg',num2str(index4));
end    
varargin(logical(loc)) = arg;
varargin{2} =strcat('''',varargin{2});
varargin{3} =strcat('''',varargin{3});
result =cell(size(result3,1)+1,max(size(result3,2),argnum+2));

result(1,1:argnum+1) = varargin(1:end-1);
result(2:end,1:size(result3,2))= result3;
save result.mat result;
disp('报表数据已经产生，正在写入Excel文件。');
disp('倘若在此过程中出错，可以加载 result.mat。');
disp('数据已经备份在里面。');
if isempty(sheet)
    xlswrite(Path,result);
else
    xlswrite(Path,result,sheet);
    setExcelformat(Path);
end

    function output =len(arg)
        if isnumeric(arg)
            output = length(arg);
        else
            output = size(arg,1);
        end
    end
    function setExcelformat (filename)
        Excel=actxserver('Excel.Application');
        Workbook=Excel.Workbooks.Open(filename);
        hExcelRange = Range(Excel,'B1:C1');
        set(hExcelRange,'NumberFormatLocal','yyyy-mm-dd');
        range1 = strcat('B3:C',num2str(size(result,1)));
        hExcelRange = Range(Excel,range1);
        set(hExcelRange,'NumberFormatLocal','0.00%');
        range2 = strcat('F3:H',num2str(size(result,1)));
        hExcelRange = Range(Excel,range2);
        set(hExcelRange,'NumberFormatLocal','0.00%');
        range3 = strcat('E3:E',num2str(size(result,1)));
        hExcelRange = Range(Excel,range3);
        set(hExcelRange,'NumberFormatLocal','#,##0.00');
        Workbook.Save;
        Excel.Workbook.Close;
        invoke(Excel,'Quit');
        delete(Excel);
    end



end