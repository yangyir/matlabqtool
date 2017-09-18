function operation_button_bdquote( hObject , eventdata , handles )
% ��ĵ�˲ʱ����
% ���Ʒ� 20170416

global QMS_INSTANCE;

stkQuote_ = QMS_INSTANCE.stkquotes_.quotestk510050;
stkQuote_.fillQuote;
quote_data_ = cell(11, 4);
quote_data_(:, 1)   = {'��5��';'��4��';'��3��';'��2��';'��1��';'���¼�';'��1��';'��2��';'��3��';'��4��';'��5��'};
quote_data_(:, end) = {'��5��';'��4��';'��3��';'��2��';'��1��';'������';'��1��';'��2��';'��3��';'��4��';'��5��'};

% ���ۺ�����
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
% ���¼ۺ����³ɽ���
quote_data_{6,2} = num2str(stkQuote_.last);
quote_data_{6,3} = num2str(stkQuote_.volume);
% ��ۺ�����
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


% �����������
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
% ��ʱ������й̶�
morningStart   = setToday + 9/24  + 30/24/60;
morningEnd     = setToday + 11/24 + 30/24/60;
afternoonStart = setToday + 13/24 + 1/24/60;
afternoonEnd   = setToday + 15/24;
dataTime = morningStart:minSecond/24/60/60:morningEnd;
dataTime = [ dataTime , afternoonStart:minSecond/24/60/60:afternoonEnd ];
time = datestr(dataTime', 'HH:MM');
time = cellstr(time)';
val  = spliceQuoteByNodes( dataTime , nodes , 'S');
% ������ͼ
axes_handle = handles.quote.axes_quote;
cla(axes_handle, 'reset')
axes(axes_handle)
plot(1:length(dataTime), val, 'b*-', 'LineWidth', 1, 'MarkerSize', 3)
% ����Y��������Сֵ
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