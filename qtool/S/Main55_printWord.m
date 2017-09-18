%% 输出成word文档，便于留存
% 程刚，140915

%生成WORD文档
try
    Word=actxGetRunningServer('Word.Application');
catch e
    disp(e);
    Word=actxserver('Word.Application');
end
set(Word,'Visible',1);


%控制WORD的COM接口
document=Word.Documents.Add;
document.PageSetup.LeftMargin = 45;
document.PageSetup.RightMargin = 45;
content=document.Content;
selection = Word.Selection;
selection.Start=content.end;

% 标题
selection.Text =  ['S回测结果'];
selection.Font.Size = 24;
selection.Font.Bold = 1;
selection.paragraphformat.Alignment = 'wdAlignParagraphCenter';
selection.MoveDown;
selection.TypeParagraph;
selection.MoveDown;
selection.TypeParagraph;

% 参数表
selection.Text =  '一、环境参数';
selection.Font.Size = 16;
selection.Font.Bold = 1;
selection.paragraphformat.Alignment = 'wdAlignParagraphLeft';
selection.MoveDown;
selection.TypeParagraph;



selection.Font.Size = 12;
selection.Font.Bold = 0;
document.Tables.Add(selection.Range,8,2);
DTI = document.Tables.Item(1);
DTI.Borders.OutsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.OutsideLineWidth = 'wdLineWidth100pt';
DTI.Borders.InsideLineStyle = 'wdLineStyleSingle';
DTI.Borders.InsideLineWidth = 'wdLineWidth100pt';



DTI.Cell(1,1).Range.Text = '时间起始';
DTI.Cell(2,1).Range.Text = '时间终止';
DTI.Cell(3,1).Range.Text = '股票池';
DTI.Cell(4,1).Range.Text = '中性化';
DTI.Cell(5,1).Range.Text = '信号衰减天数';
DTI.Cell(6,1).Range.Text = '截尾';
DTI.Cell(7,1).Range.Text = '最高仓位';
DTI.Cell(8,1).Range.Text = '换仓时间';

DTI.Cell(1,2).Range.Text = sprintf('%s',sDay);
DTI.Cell(2,2).Range.Text = sprintf('%s',eDay);
DTI.Cell(3,2).Range.Text = sprintf('%s',universe);
DTI.Cell(4,2).Range.Text = sprintf('%s',neutralizeMethod);
DTI.Cell(5,2).Range.Text = sprintf('%d',expDecayDays);
DTI.Cell(6,2).Range.Text = sprintf('%0.1f%%',100*truncatePct);
DTI.Cell(7,2).Range.Text = sprintf('%0.1f%%', 100*maxPosition);
DTI.Cell(8,2).Range.Text = sprintf('%s',tradeTime);


selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.MoveDown;
selection.TypeParagraph;



% s
selection.Text =  '二、s公式:';
selection.Font.Size = 16;
selection.Font.Bold = 1;
selection.paragraphformat.Alignment = 'wdAlignParagraphLeft';
selection.MoveDown;
selection.TypeParagraph;

txt = '';
fid = fopen(['s_entry.m'], 'r');
aline = fgetl(fid);
while aline ~= -1
    txt = sprintf('%s%s',txt,aline);
    aline = fgets(fid);
end
fclose(fid); 

selection.Text =  txt;
selection.Font.Size = 12;
selection.Font.Bold = 0;
selection.MoveDown;
selection.TypeParagraph;
selection.MoveDown;
selection.TypeParagraph;


% 图片
selection.Text =  '三、图';
selection.Font.Size = 16;
selection.Font.Bold = 1;
selection.MoveDown;
selection.TypeParagraph;

selection.Font.Bold = 0;
selection.Font.Size = 10;


i = hfig210;
set(i,'Position',[0,0,640,500]);
hgexport(i,'-clipboard');
selection.Paste;

i = hfig202;
set(i,'Position',[0,0,640,500]);
hgexport(i,'-clipboard');
selection.Paste;



% 储存
path = cd;
docname = 'test.docx';
document.SaveAs2([path , docname]);
document.Close