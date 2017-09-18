function [] = reportWord2(xlsFilename)
% 给excel版本nav1，nav2数据，自动生成word报告，比较两个nav
% 具体细节见FAQ
% 输入：
%     xlsFilename： excel文件的名字（含路径），输入的nav1，nav2数据在里面
% 输出：
%     一篇word文档，在当前路径下
% ---------------------------------------
% 唐一鑫，20150730，出版本，建立在陈思思提供的word模板基础上


%% Input
[nav,date]=xlsread(xlsFilename,1);

nav1 = nav(:,1);
nav1 = nav1(~isnan(nav1));

nav2 = nav(:,3);
nav2 = nav2(~isnan(nav2));

date1 = date(:,1);
date1 = date1(~strcmp(date1,''));
date2 = date(:,3);
date2 = date2(~strcmp(date2,''));

formatIn = 'yyyy-mm-dd';
Date1 = datenum(date1,formatIn);
Date2 = datenum(date2,formatIn);

%% Preprocess
[nav1,nav2] = process(nav1, Date1, nav2, Date2);

%% set up word

filespec_user = [pwd,'\test2.doc'];
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
Selection.Font.Size = small;
Selection.TypeParagraph;



% 基金净值图
Selection.text = '基金净值走势';
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

zft = figure('units','normalized','position',...
    [0.280469 0.553385 0.728906 0.551302],'visible','off'); % 新建图形窗口，设为不可见
rplot2(Date1, nav1, Date2, nav2);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);

Selection.TypeParagraph;
Selection.start = Content.end;
Selection.TypeParagraph;
% 收益 净值 曲线
Selection.text = '收益-净值曲线';
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

zft = figure('units','normalized','position',...
    [0.280469 0.553385 0.528906 0.551302],'visible','off'); % 新建图形窗口，设为不可见
rplot2b(nav1,Date1,nav2,Date2);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);

Selection.TypeParagraph;
Selection.start = Content.end;
Selection.TypeParagraph;
% 收益，波动，性价比比较
Selection.text = '业内量化对冲相关收益、波动、性价比比较';
Selection.MoveDown;
Selection.TypeParagraph;Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,4,7);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%设置内边框的线型
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';



row_height = [40,30,30,30]; % 设置行高


for i = 1:4
    DTI.Rows.Item(i).Height = row_height(i);
end

Selection.Start = Content.end;
Selection.TypeParagraph;

for i = 1:6
DTI.Cell(1, 1).Merge(DTI.Cell(1, 2))
end

DTI.Cell(1,1).Range.Text = '业内量化对冲相关收益、波动、性价比比较';
DTI.Cell(2,1).Range.Text = '基金代码';
DTI.Cell(2,2).Range.Text = '成立日期';
DTI.Cell(2,3).Range.Text = '截止日期';
DTI.Cell(2,4).Range.Text = '成立以来    年化收益率';
DTI.Cell(2,5).Range.Text = '成立以来    夏普比率';
DTI.Cell(2,6).Range.Text = '成立以来    年化波动率';
DTI.Cell(2,7).Range.Text = '成立以来    最大月回撤';
DTI.Cell(3,1).Range.Text = '基金1';
DTI.Cell(4,1).Range.Text = '基金2';

DTI.Cell(3,2).Range.Text = char(date1(1));
DTI.Cell(4,2).Range.Text = char(date2(1));

DTI.Cell(3,3).Range.Text = char(date1(end));
DTI.Cell(4,3).Range.Text = char(date1(end));

[navmonth1] = nav2month(nav1 , Date1);
[navmonth2] = nav2month(nav2 , Date2);
% digits set
digits(3);

DTI.Cell(3,4).Range.Text = [char(vpa(evl.annualYield(navmonth1,'m')*100)),'%'];
DTI.Cell(4,4).Range.Text = [char(vpa(evl.annualYield(navmonth2,'m')*100)),'%'];

DTI.Cell(3,6).Range.Text = [char(vpa(evl.annualVol(navmonth1,'m')*100)),'%'];
DTI.Cell(4,6).Range.Text = [char(vpa(evl.annualVol(navmonth2,'m')*100)),'%'];

DTI.Cell(3,5).Range.Text = num2str(evl.SharpeRatio(navmonth1,0.05,'m'));
DTI.Cell(4,5).Range.Text = num2str(evl.SharpeRatio(navmonth2,0.05,'m'));

DTI.Cell(3,7).Range.Text = [char(vpa(evl.maxDrawDown(navmonth1)*100)),'%'];
DTI.Cell(4,7).Range.Text = [char(vpa(evl.maxDrawDown(navmonth2)*100)),'%'];


DTI.Cell(1,1).Range.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
DTI.Cell(1,1).VerticalAlignment = 'wdCellAlignVerticalCenter';
for i = 2:4
    for j = 1:7
        DTI.Cell(i,j).Range.ParagraphFormat.Alignment = 'wdAlignParagraphCenter';
        DTI.Cell(i,j).VerticalAlignment = 'wdCellAlignVerticalCenter';    
    end
end


end


