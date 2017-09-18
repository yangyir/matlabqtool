function operation_button_bdquote( hObject , eventdata , handles )
% 标的的瞬时行情
% 吴云峰 20170416

global QMS_INSTANCE;

stkQuote_ = QMS_INSTANCE.stkquotes_.quotestk510050;
stkQuote_.fillQuote;
quote_data_ = cell(11, 4);
quote_data_(:, 1)   = {'卖5价';'卖4价';'卖3价';'卖2价';'卖1价';'最新价';'买1价';'买2价';'买3价';'买4价';'买5价'};
quote_data_(:, end) = {'卖5量';'卖4量';'卖3量';'卖2量';'卖1量';'最新量';'买1量';'买2量';'买3量';'买4量';'买5量'};

% 卖价和卖量
quote_data_{1,2} = num2str(stkQuote_.askP5);
quote_data_{1,3} = num2str(stkQuote_.askQ5);
quote_data_{2,2} = num2str(stkQuote_.askP4);
quote_data_{2,3} = num2str(stkQuote_.askQ4);
quote_data_{3,2} = num2str(stkQuote_.askP3);
quote_data_{3,3} = num2str(stkQuote_.askQ3);
quote_data_{4,2} = num2str(stkQuote_.askP2);
quote_data_{4,3} = num2str(stkQuote_.askQ2);
quote_data_{5,2} = num2str(stkQuote_.askP1);
quote_data_{5,3} = num2str(stkQuote_.askQ1);
% 最新价和最新成交量
quote_data_{6,2} = num2str(stkQuote_.last);
quote_data_{6,3} = num2str(stkQuote_.volume);
% 买价和买量
quote_data_{7,2}  = num2str(stkQuote_.bidP1);
quote_data_{7,3}  = num2str(stkQuote_.bidQ1);
quote_data_{8,2}  = num2str(stkQuote_.bidP2);
quote_data_{8,3}  = num2str(stkQuote_.bidQ2);
quote_data_{9,2}  = num2str(stkQuote_.bidP3);
quote_data_{9,3}  = num2str(stkQuote_.bidQ3);
quote_data_{10,2} = num2str(stkQuote_.bidP4);
quote_data_{10,3} = num2str(stkQuote_.bidQ4);
quote_data_{11,2} = num2str(stkQuote_.bidP5);
quote_data_{11,3} = num2str(stkQuote_.bidQ5);
set(handles.quote.table_quote, 'Data', quote_data_);


% 标的内日行情
[nT, nK] = size(QMS_INSTANCE.callQuotes_.data);
for t = 1:nT
    for k = 1:nK
        hist = QMS_INSTANCE.historic_call_m2tk_.data(t, k);
        if hist.is_obj_valid
            nodes = hist.node;
            break;
        end
    end
end
minSecond      = 60;
setToday       = floor( nodes(1).quoteTime(1) );
% 将时间轴进行固定
morningStart   = setToday + 9/24  + 30/24/60;
morningEnd     = setToday + 11/24 + 30/24/60;
afternoonStart = setToday + 13/24 + 1/24/60;
afternoonEnd   = setToday + 15/24;
dataTime = morningStart:minSecond/24/60/60:morningEnd;
dataTime = [ dataTime , afternoonStart:minSecond/24/60/60:afternoonEnd ];
time = datestr(dataTime', 'HH:MM');
time = cellstr(time)';
val  = spliceQuoteByNodes( dataTime , nodes , 'S');
% 进行作图
axes_handle = handles.quote.axes_quote;
cla(axes_handle, 'reset')
axes(axes_handle)
plot(1:length(dataTime), val, 'b*-', 'LineWidth', 1, 'MarkerSize', 3)
% 设置Y轴的最大最小值
ymax = nanmax(val) + 0.001;
ymin = nanmin(val) - 0.001;
set(axes_handle, 'YLim', [ymin, ymax])
set(axes_handle, 'XLim', [1, 241])
set(axes_handle, 'XTick', 1:60:241)
set(axes_handle, 'XTickLabel', time(1:60:241))
set(axes_handle, 'FontWeight', 'bold', 'FontSize', 9)



grid on;
hold off












end