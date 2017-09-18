function [] = reportWord(xlsFilename, period)
% 给excel版本nav数据，自动生成word报告，评价单nav
% 具体细节见FAQ
% [] = reportWord(xlsFilename, period)
% 输入：
%     xlsFilename： excel文件的名字（含路径），输入的nav数据在里面
%     period：数据周期， d245/d360/d365/w/m/q/y
% 输出：
%     一篇word文档，在当前路径下
% ---------------------------------------
% 唐一鑫，20150730，出版本，建立在陈思思提供的word模板基础上

%% Input
[nav1,date1]=xlsread(xlsFilename,1);
formatIn = 'yyyy-mm-dd';
Date1 = datenum(date1,formatIn);


% 提取不同时间段的数据

Date.month = Date1(Date1>today-30);
nav.month =  nav1(Date1>today-30);

Date.thrmonth = Date1(Date1>today-90);
nav.thrmonth =  nav1(Date1>today-90);

Date.sixmonth = Date1(Date1>today-180);
nav.sixmonth =  nav1(Date1>today-180);

Date.year = Date1(Date1>today-365);
nav.year =  nav1(Date1>today-365);

Date.twoyear = Date1(Date1>today-365*2);
nav.twoyear =  nav1(Date1>today-365*2);

Date.fivyear = Date1(Date1>today-365*5);
nav.fivyear =  nav1(Date1>today-365*5);

flag=ones(6,1);
if(length(Date.month)==length(Date.thrmonth) && ~isempty(Date.month))
    flag=[1,0,0,0,0,0];
else if(length(Date.thrmonth)==length(Date.sixmonth)&& ~isempty(Date.thrmonth))
        flag=[1,1,0,0,0,0];
    else if(length(Date.sixmonth)==length(Date.year)&& ~isempty(Date.sixmonth))
            flag=[1,1,1,0,0,0];
        else if(length(Date.year)==length(Date.twoyear)&& ~isempty(Date.year))
                flag=[1,1,1,1,0,0];
            else if(length(Date.twoyear)==length(Date.fivyear)&& ~isempty(Date.twoyear))
                    flag=[1,1,1,1,1,0];
                end
            end
        end
    end
end

% 归一化

nav1=nav1./nav1(1);

if(~isempty(nav.month))
    nav.month=nav.month./nav.month(1);
end

if(~isempty(nav.thrmonth))
    Date.thrmonth=Date.thrmonth./Date.thrmonth(1);
end
if(~isempty(nav.sixmonth))
    Date.sixmonth=Date.sixmonth./Date.sixmonth(1);
end
if(~isempty(nav.year))
    Date.year=Date.year./Date.year(1);
end
if(~isempty(nav.twoyear))
    Date.twoyear=Date.twoyear./Date.twoyear(1);
end
if(~isempty(nav.fivyear))
    Date.fivyear=Date.fivyear./Date.fivyear(1);
end

%% set up word

filespec_user = [pwd,'\test.doc'];
try
    Word=actxGetRunningServer('Word.Application');
catch
    Word=actxserver('Word.Application');
end

set(Word,'Visible',1);

if exist(filespec_user,'file');
    Document = Word.Documents.Open(filespec_user);
else
    Document=Word.Documents.Add;
    Document.SaveAs2(filespec_user);
end

%% edit report
Content = Document.Content;
Selection = Word.Selection;
% Paragraphformat = Selection.ParagraphFormat;

% 设定页面大小
Document.PageSetup.TopMargin = 60;
Document.PageSetup.BottomMargin = 45;
Document.PageSetup.LeftMargin = 45;
Document.PageSetup.RightMargin = 45;

%
big=20;
small=9;

Selection.text = 'Report';
Selection.Font.Size =big;
Selection.paragraphformat.Alignment='wdAlignParagraphCenter';
Selection.MoveDown;
Selection.TypeParagraph;
Selection.text = date;
Selection.Font.Size = small;
Selection.Font.Bold =1;
Selection.paragraphformat.Alignment='wdAlignParagraphCenter';

Selection.MoveDown;
Selection.TypeParagraph;
Selection.TypeParagraph;
Selection.TypeParagraph;


% 加页眉、页脚
% VBA 原文
%  Selection.TypeParagraph
%     If ActiveWindow.View.SplitSpecial <> wdPaneNone Then
%         ActiveWindow.Panes(2).Close
%     End If
%     If ActiveWindow.ActivePane.View.Type = wdNormalView Or ActiveWindow. _
%         ActivePane.View.Type = wdOutlineView Then
%         ActiveWindow.ActivePane.View.Type = wdPrintView
%     End If
%     ActiveWindow.ActivePane.View.SeekView = wdSeekCurrentPageHeader
%     Selection.TypeText Text:="民生银行 "


% 页眉
Word.activeWindow.ActivePane.view.seekView = 'wdSeekCurrentPageHeader';
logoPath = 'D:\chenggang2\1509 杨洋-评价系统\4.界面 - 吴云峰\';
% logoPath = 'P:\1509 杨洋-评价系统\4.界面 - 吴云峰\';
logofilename = [logoPath '\minsheng_logo_1_5.jpg'];
%     Selection.InlineShapes.AddPicture FileName:= _
%         "P:\1509 杨洋-评价系统\4.界面 - 吴云峰\minsheng_logo.jpg", LinkToFile:=False, _
%         SaveWithDocument:=True
Selection.InlineShapes.AddPicture(logofilename,false, true);
Selection.ParagraphFormat.Alignment = 'wdAlignParagraphRight';


% 页脚显示日期、页码
Word.activeWindow.ActivePane.view.seekView = 'wdSeekCurrentPageFooter';
% Selection.TypeText( ['报告日期：' datestr(today(),'yyyy-mm-dd') ] );
Selection.TypeText( sprintf( '报告日期：%s\t\t',datestr(today(),'yyyy-mm-dd')) );
Selection.ParagraphFormat.Alignment = 'wdAlignParagraphLeft';
% Selection.MoveRight;
Selection.Range.Text = '第';
Selection.EndKey;
Selection.Fields.Add(Selection.Range, [], 'Page');
Selection.EndKey;
Selection.Range.Text = '页';




% 回正文
Word.ActiveWindow.ActivePane.view.seekView = 'wdSeekMainDocument';

% 基金净值图
Selection.text = ['基金净值走势','    (截止日期）', char(date1(end))];
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

% zft = figure('units','normalized','position',...
%     [0.280469 0.553385 0.628906 0.651302],'visible','on'); % 新建图形窗口，设为不可见
zft = figure('units','normalized','position',...
    [0.2 0.2 0.728906 0.651302],'visible','off'); % 新建图形窗口，设为不可见


rPlot(nav1,Date1);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);

Selection.TypeParagraph;
% 历史业绩表
Selection.start = Content.end;
Selection.TypeParagraph;
Selection.text = ['历史业绩表','    (截止日期）', char(date1(end))];
Selection.MoveDown;
Selection.TypeParagraph;
Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,3,8);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%设置内边框的线型
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';


column_width = [70,65,65,65,65,65,65,65];% 设置列宽，单位为磅
row_height = [20,20,20]; % 设置行高

for i = 1:8
    DTI.Columns.Item(i).Width = column_width(i);
end
for i = 1:3
    DTI.Rows.Item(i).Height = row_height(i);
end

Selection.Start = Content.end;
Selection.TypeParagraph;

DTI.Cell(1,2).Range.Text = '近一个月';
DTI.Cell(1,3).Range.Text = '近三个月';
DTI.Cell(1,4).Range.Text = '近六个月';
DTI.Cell(1,5).Range.Text = '近一年';
DTI.Cell(1,6).Range.Text = '近两年';
DTI.Cell(1,7).Range.Text = '近五年';
DTI.Cell(1,8).Range.Text = '成立以来';
DTI.Cell(2,1).Range.Text = '股票净值';
DTI.Cell(3,1).Range.Text = '沪深300';
%digits set
digits(3);


if(length(nav.month)<=1)
    DTI.Cell(2,2).Range.Text = 'null';
else
    DTI.Cell(2,2).Range.Text = [char(vpa(evl.annualYield(nav.month,period))*100),'%'];
end

if(flag(2)==0 || length(nav.thrmonth)<=1)
    DTI.Cell(2,3).Range.Text = 'null';
else
    DTI.Cell(2,3).Range.Text =  [char(vpa(evl.annualYield(nav.thrmonth,period))*100),'%'];
end

if(flag(3)==0|| length(nav.sixmonth)<=1)
    DTI.Cell(2,4).Range.Text = 'null';
else
    DTI.Cell(2,4).Range.Text =  [char(vpa(evl.annualYield(nav.sixmonth,period))*100),'%'];
end

if(flag(4)==0|| length(nav.year)<=1)
    DTI.Cell(2,5).Range.Text = 'null';
else
    DTI.Cell(2,5).Range.Text =  [char(vpa(evl.annualYield(nav.year,period))*100),'%'];
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(2,6).Range.Text = 'null';
else
    DTI.Cell(2,6).Range.Text =  [char(vpa(evl.annualYield(nav.twoyear,period))*100),'%'];
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(2,7).Range.Text = 'null';
else
    DTI.Cell(2,7).Range.Text =  [char(vpa(evl.annualYield(nav.fivyear,period))*100),'%'];
end

DTI.Cell(2,8).Range.Text =  [char(vpa(evl.annualYield(nav1,period))*100),'%'];


DTI.Cell(3,2).Range.Text = '-22.65%';
DTI.Cell(3,3).Range.Text = '-5.48%';
DTI.Cell(3,4).Range.Text = '15.78%';
DTI.Cell(3,5).Range.Text = '91.64%';
DTI.Cell(3,6).Range.Text = '84.64%';
DTI.Cell(3,7).Range.Text = '55.13%';
DTI.Cell(3,8).Range.Text = 'null';
Selection.TypeParagraph;
% 风险评估表格
Selection.text = ['风险评估指标','    (截止日期）', char(date1(end))];
Selection.MoveDown;
Selection.TypeParagraph;Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,6,5);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%设置内边框的线型
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';


column_width = [70,65,65,65,65];% 设置列宽，单位为磅
row_height = [30,30,30,30,30,30]; % 设置行高

for i = 1:5
    DTI.Columns.Item(i).Width = column_width(i);
end
for i = 1:6
    DTI.Rows.Item(i).Height = row_height(i);
end

Selection.Start = Content.end;
Selection.TypeParagraph;

DTI.Cell(2,1).Range.Text = '年化收益率';
DTI.Cell(3,1).Range.Text = '年化波动率';
DTI.Cell(4,1).Range.Text = '最大回撤';
DTI.Cell(5,1).Range.Text = '夏普比率';
DTI.Cell(6,1).Range.Text = 'Calmar比率';
DTI.Cell(1,2).Range.Text = '近一年';
DTI.Cell(1,3).Range.Text = '近两年';
DTI.Cell(1,4).Range.Text = '近五年';
DTI.Cell(1,5).Range.Text = '成立以来';

% annualized yield
if(flag(4)==0 || length(nav.year)<=1)
    DTI.Cell(2,2).Range.Text = 'null';
else DTI.Cell(2,2).Range.Text = [char(vpa(evl.annualYield(nav.year,period))*100),'%'];
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(2,3).Range.Text = 'null';
else DTI.Cell(2,3).Range.Text = [char(vpa(evl.annualYield(nav.twoyear,period))*100),'%'];
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(2,4).Range.Text = 'null';
else DTI.Cell(2,4).Range.Text = [char(vpa(evl.annualYield(nav.fivyear,period))*100),'%'];
end

DTI.Cell(2,5).Range.Text = [char(vpa(evl.annualYield(nav1,period))*100),'%'];

% annualized vol
if(flag(4)==0|| length(nav.year)<=1)
    DTI.Cell(3,2).Range.Text = 'null';
else DTI.Cell(3,2).Range.Text = [char(vpa(evl.annualVol(nav.year,period))*100),'%'];
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(3,3).Range.Text = 'null';
else DTI.Cell(3,3).Range.Text = [char(vpa(evl.annualVol(nav.twoyear,period))*100),'%'];
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(3,4).Range.Text = 'null';
else DTI.Cell(3,4).Range.Text =[char(vpa(evl.annualVol(nav.fivyear,period))*100),'%'];
end

DTI.Cell(3,5).Range.Text = [char(vpa(evl.annualVol(nav1,period))*100),'%'];

% MDD
if(flag(4)==0 || length(nav.year)<=1)
    DTI.Cell(4,2).Range.Text = 'null';
else DTI.Cell(4,2).Range.Text = [char(vpa(evl.maxDrawDown(nav.year)*100)),'%'];
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(4,3).Range.Text= 'null';
else DTI.Cell(4,3).Range.Text =[char(vpa(evl.maxDrawDown(nav.twoyear)*100)),'%'];
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(4,4).Range.Text = 'null';
else DTI.Cell(4,4).Range.Text = [char(vpa(evl.maxDrawDown(nav.fivyear)*100)),'%'];
end

DTI.Cell(4,5).Range.Text = [char(vpa(evl.maxDrawDown(nav1)*100)),'%'];

% sharpe r
if(flag(4)==0|| length(nav.year)<=1)
    DTI.Cell(5,2).Range.Text = 'null';
else DTI.Cell(5,2).Range.Text = num2str(evl.SharpeRatio(nav.year,0.05,period));
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(5,3).Range.Text = 'null';
else DTI.Cell(5,3).Range.Text = num2str(evl.SharpeRatio(nav.twoyear,0.05,period));
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(5,4).Range.Text = 'null';
else DTI.Cell(5,4).Range.Text = num2str(evl.SharpeRatio(nav.fivyear,0.05,period));
end

DTI.Cell(5,5).Range.Text = num2str(evl.SharpeRatio(nav1,0.05,period));

% calmar r
if(flag(4)==0|| length(nav.year)<=1)
    DTI.Cell(6,2).Range.Text = 'null';
else DTI.Cell(6,2).Range.Text = num2str(evl.CalmarRatio(nav.year,0.05,period));
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(6,3).Range.Text = 'null';
else DTI.Cell(6,3).Range.Text =num2str(evl.CalmarRatio(nav.twoyear,0.05,period));
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(6,4).Range.Text = 'null';
else DTI.Cell(6,4).Range.Text = num2str(evl.CalmarRatio(nav.fivyear,0.05,period));
end

DTI.Cell(6,5).Range.Text = num2str(evl.CalmarRatio(nav1,0.05,period));
Selection.TypeParagraph;
%  回撤图
Selection.text = ['回撤走势','    (截止日期）', char(date1(end))];
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

zft = figure('units','normalized','position',...
    [0.280469 0.553385 0.728906 0.551302],'visible','off'); % 新建图形窗口，设为不可见
mdd(nav1,Date1);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);
Selection.start = Content.end;
Selection.TypeParagraph;
Selection.TypeParagraph;
% 历史业绩图
Selection.TypeParagraph;
Selection.text = ['历史业绩图','    (截止日期）', char(date1(end))];
Selection.MoveDown;
Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,4,3);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%设置内边框的线型
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';



row_height = [10,80,10,80]; % 设置行高
for i = 1:4
    DTI.Rows.Item(i).Height = row_height(i);
end
Selection.Start = Content.end;
Selection.TypeParagraph;

DTI.Cell(1,1).Range.Text = '近一个月';
DTI.Cell(1,2).Range.Text = '近三个月';
DTI.Cell(1,3).Range.Text = '近六个月';
DTI.Cell(3,1).Range.Text = '近一年';
DTI.Cell(3,2).Range.Text = '近两年';
DTI.Cell(3,3).Range.Text = '近五年';

if(length(nav.month)<=1)
    DTI.Cell(2,1).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.month,Date.month);
    hgexport(zft, '-clipboard');
    DTI.Cell(2,1).Range.Paste;
end

if(flag(2)==0 || length(nav.thrmonth)<=1)
    DTI.Cell(2,2).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.thrmonth,Date.thrmonth);
    hgexport(zft, '-clipboard');
    DTI.Cell(2,2).Range.Paste
    
end

if(flag(3)==0|| length(nav.sixmonth)<=1)
    DTI.Cell(2,3).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.sixmonth,Date.sixmonth);
    hgexport(zft, '-clipboard');
    DTI.Cell(2,3).Range.Paste
end

if(flag(4)==0|| length(nav.year)<=1)
    DTI.Cell(4,1).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.year,Date.year);
    hgexport(zft, '-clipboard');
    DTI.Cell(4,1).Range.Paste
end

if(flag(5)==0|| length(nav.twoyear)<=1)
    DTI.Cell(4,2).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.twoyear,Date.twoyear);
    hgexport(zft, '-clipboard');
    DTI.Cell(4,2).Range.Paste
end

if(flag(6)==0|| length(nav.fivyear)<=1)
    DTI.Cell(4,3).Range.Text = 'null';
else
    zft = figure('units','normalized','visible','off');
    rPlot(nav.fivyear,Date.fivyear);
    hgexport(zft, '-clipboard');
    DTI.Cell(4,3).Range.Paste
end

for i = 1:4
    for j = 1:3
        DTI.Cell(i,j).Range.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        DTI.Cell(i,j).VerticalAlignment = 'wdCellAlignVerticalCenter';
    end
end
Selection.TypeParagraph;
% 移动指标图
Selection.TypeParagraph;
Selection.text = ['移动指标图','    (截止日期）', char(date1(end))];
Selection.MoveDown;
Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,6,3);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%设置内边框的线型
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';

row_height = [10,100,10,100,10,100]; % 设置行高
row_weight = [100,150,150];
for i = 1:6
    DTI.Rows.Item(i).Height = row_height(i);
end
for i = 1:3
    DTI.Columns.Item(i).Width = row_weight(i);
end
Selection.Start = Content.end;
Selection.TypeParagraph;

DTI.Cell(1, 1).Merge(DTI.Cell(2, 1));
DTI.Cell(3, 1).Merge(DTI.Cell(4, 1));
DTI.Cell(5, 1).Merge(DTI.Cell(6, 1));

DTI.Cell(1,1).Range.Text = '距离移动量';
DTI.Cell(3,1).Range.Text = '波动率移动量';
DTI.Cell(5,1).Range.Text = '其它移动量';
DTI.Cell(1,2).Range.Text = 'dist';
DTI.Cell(1,3).Range.Text = 'shift';
DTI.Cell(3,2).Range.Text = 'volatility';
DTI.Cell(3,3).Range.Text = 'upvolatility';
DTI.Cell(5,2).Range.Text = 'K';
DTI.Cell(5,3).Range.Text = 'KKK';

zft = figure('units','normalized','visible','off');
mPlot(mv.dist(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(2,2).Range.Paste;

zft = figure('units','normalized','visible','off');
mPlot(mv.shift(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(2,3).Range.Paste;

zft = figure('units','normalized','visible','off');
mPlot(mv.vol(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(4,2).Range.Paste;

zft = figure('units','normalized','visible','off');
mPlot(mv.upvol(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(4,3).Range.Paste;

zft = figure('units','normalized','visible','off');
mPlot(mv.k(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(6,2).Range.Paste;

zft = figure('units','normalized','visible','off');
mPlot(mv.kkk(nav1),Date1);
hgexport(zft, '-clipboard');
DTI.Cell(6,3).Range.Paste;

for i = 1:2:5
    for j = 1:1
        DTI.Cell(i,j).Range.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        DTI.Cell(i,j).VerticalAlignment = 'wdCellAlignVerticalCenter';
    end
end

end
