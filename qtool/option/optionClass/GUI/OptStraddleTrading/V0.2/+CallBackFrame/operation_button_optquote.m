function operation_button_optquote( hObject , eventdata , handles )
% 组合的瞬时行情和日内行情
% 吴云峰 20170416

global QMS_INSTANCE;
opt_entrustinfo_ = get(handles.asset.table_optopensel, 'Data');


% 时间的配置
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

% 瞬时行情
last = 0;
bidP = 0;
askP = 0;
volume = 99999;
bidQ   = 99999;
askQ   = 99999;
val    = zeros(length(time), 1);


for t = 1:nT
    for k = 1:nK
        
        % Call
        optQuote_ = QMS_INSTANCE.callQuotes_.data(t, k);
        if optQuote_.is_obj_valid
            optAmt = opt_entrustinfo_{2*t-1, k};
            if isempty(optAmt)
            else
                optAmt = str2double(optAmt);
                if isnan(optAmt)
                else
                    last   = last + optAmt * optQuote_.last;
                    volume = min([volume, optQuote_.volume]);
                    if optAmt > 0
                        bidP = bidP + optAmt * optQuote_.bidP1;
                        bidQ = min([bidQ, optQuote_.bidQ1]);
                        askP = askP + optAmt * optQuote_.askP1;
                        askQ = min([askQ, optQuote_.askQ1]);
                    else
                        bidP = bidP + optAmt * optQuote_.askP1;
                        bidQ = min([bidQ, optQuote_.askQ1]);
                        askP = askP + optAmt * optQuote_.bidP1;
                        askQ = min([askQ, optQuote_.bidQ1]);
                    end
                    % 获取日内数据
                    inner_ = QMS_INSTANCE.historic_call_m2tk_.data(t, k);
                    nodes  = inner_.node;
                    val    = val + optAmt * spliceQuoteByNodes( dataTime , nodes , 'last');
                end
            end
        end
        
        % Put
        optQuote_ = QMS_INSTANCE.putQuotes_.data(t, k);
        if optQuote_.is_obj_valid
            optAmt = opt_entrustinfo_{2*t, k};
            if isempty(optAmt)
            else
                optAmt = str2double(optAmt);
                if isnan(optAmt)
                else
                    last   = last + optAmt * optQuote_.last;
                    volume = min([volume, optQuote_.volume]);
                    if optAmt > 0
                        bidP = bidP + optAmt * optQuote_.bidP1;
                        bidQ = min([bidQ, optQuote_.bidQ1]);
                        askP = askP + optAmt * optQuote_.askP1;
                        askQ = min([askQ, optQuote_.askQ1]);
                    else
                        bidP = bidP + optAmt * optQuote_.askP1;
                        bidQ = min([bidQ, optQuote_.askQ1]);
                        askP = askP + optAmt * optQuote_.bidP1;
                        askQ = min([askQ, optQuote_.bidQ1]);
                    end
                    % 获取日内数据
                    inner_ = QMS_INSTANCE.historic_put_m2tk_.data(t, k);
                    nodes  = inner_.node;
                    val    = val + optAmt * spliceQuoteByNodes( dataTime , nodes , 'last');
                end
            end
        end
        
    end
end

quote_data_ = cell(3, 4);
quote_data_(:, 1)   = {'卖1价';'最新价';'买1价'};
quote_data_(:, end) = {'卖1量';'最新量';'买1量'};
if last > 0
    quote_data_{1, 2}   = num2str(askP);
    quote_data_{2, 2}   = num2str(last);
    quote_data_{3, 2}   = num2str(bidP);
    quote_data_{1, 3}   = num2str(askQ);
    quote_data_{2, 3}   = num2str(volume);
    quote_data_{3, 3}   = num2str(bidQ);
else
    quote_data_{1, 2}   = num2str(-bidP);
    quote_data_{2, 2}   = num2str(-last);
    quote_data_{3, 2}   = num2str(-askP);
    quote_data_{1, 3}   = num2str(bidQ);
    quote_data_{2, 3}   = num2str(volume);
    quote_data_{3, 3}   = num2str(askQ);
end
set(handles.quote.table_quote, 'Data', quote_data_)


% 进行作图
axes_handle = handles.quote.axes_quote;
cla(axes_handle, 'reset')
axes(axes_handle)
val = abs(val);
plot(1:length(dataTime), val, 'b*-', 'LineWidth', 1, 'MarkerSize', 3)
% 设置Y轴的最大最小值
ymax = nanmax(val) + 0.0005;
ymin = nanmin(val) - 0.0005;
set(axes_handle, 'YLim', [ymin, ymax])
set(axes_handle, 'XLim', [1, 241])
set(axes_handle, 'XTick', 1:60:241)
set(axes_handle, 'XTickLabel', time(1:60:241))
set(axes_handle, 'FontWeight', 'bold', 'FontSize', 9)
grid on;
hold off











end