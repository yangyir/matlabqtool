function [] = reportWord2(xlsFilename)
% ��excel�汾nav1��nav2���ݣ��Զ�����word���棬�Ƚ�����nav
% ����ϸ�ڼ�FAQ
% ���룺
%     xlsFilename�� excel�ļ������֣���·�����������nav1��nav2����������
% �����
%     һƪword�ĵ����ڵ�ǰ·����
% ---------------------------------------
% ��һ�Σ�20150730�����汾�������ڳ�˼˼�ṩ��wordģ�������


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

% �趨ҳ���С
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



% ����ֵͼ
Selection.text = '����ֵ����';
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

zft = figure('units','normalized','position',...
    [0.280469 0.553385 0.728906 0.551302],'visible','off'); % �½�ͼ�δ��ڣ���Ϊ���ɼ�
rplot2(Date1, nav1, Date2, nav2);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);

Selection.TypeParagraph;
Selection.start = Content.end;
Selection.TypeParagraph;
% ���� ��ֵ ����
Selection.text = '����-��ֵ����';
Selection.paragraphformat.Alignment='wdAlignParagraphLeft';
Selection.MoveDown;
Selection.TypeParagraph;

zft = figure('units','normalized','position',...
    [0.280469 0.553385 0.528906 0.551302],'visible','off'); % �½�ͼ�δ��ڣ���Ϊ���ɼ�
rplot2b(nav1,Date1,nav2,Date2);
hgexport(zft, '-clipboard');
Selection.Range.Paste;
delete(zft);

Selection.TypeParagraph;
Selection.start = Content.end;
Selection.TypeParagraph;
% ���棬�������Լ۱ȱȽ�
Selection.text = 'ҵ�������Գ�������桢�������Լ۱ȱȽ�';
Selection.MoveDown;
Selection.TypeParagraph;Selection.TypeParagraph;

Tables = Document.Tables.Add(Selection.Range,4,7);
DTI = Tables;
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth150pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';%�����ڱ߿������
DTI.Borders.InsideLineWidth = 'wdLineWidth150pt';



row_height = [40,30,30,30]; % �����и�


for i = 1:4
    DTI.Rows.Item(i).Height = row_height(i);
end

Selection.Start = Content.end;
Selection.TypeParagraph;

for i = 1:6
DTI.Cell(1, 1).Merge(DTI.Cell(1, 2))
end

DTI.Cell(1,1).Range.Text = 'ҵ�������Գ�������桢�������Լ۱ȱȽ�';
DTI.Cell(2,1).Range.Text = '�������';
DTI.Cell(2,2).Range.Text = '��������';
DTI.Cell(2,3).Range.Text = '��ֹ����';
DTI.Cell(2,4).Range.Text = '��������    �껯������';
DTI.Cell(2,5).Range.Text = '��������    ���ձ���';
DTI.Cell(2,6).Range.Text = '��������    �껯������';
DTI.Cell(2,7).Range.Text = '��������    ����»س�';
DTI.Cell(3,1).Range.Text = '����1';
DTI.Cell(4,1).Range.Text = '����2';

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


