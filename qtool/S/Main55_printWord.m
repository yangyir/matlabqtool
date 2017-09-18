%% �����word�ĵ�����������
% �̸գ�140915

%����WORD�ĵ�
try
    Word=actxGetRunningServer('Word.Application');
catch e
    disp(e);
    Word=actxserver('Word.Application');
end
set(Word,'Visible',1);


%����WORD��COM�ӿ�
document=Word.Documents.Add;
document.PageSetup.LeftMargin = 45;
document.PageSetup.RightMargin = 45;
content=document.Content;
selection = Word.Selection;
selection.Start=content.end;

% ����
selection.Text =  ['S�ز���'];
selection.Font.Size = 24;
selection.Font.Bold = 1;
selection.paragraphformat.Alignment = 'wdAlignParagraphCenter';
selection.MoveDown;
selection.TypeParagraph;
selection.MoveDown;
selection.TypeParagraph;

% ������
selection.Text =  'һ����������';
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



DTI.Cell(1,1).Range.Text = 'ʱ����ʼ';
DTI.Cell(2,1).Range.Text = 'ʱ����ֹ';
DTI.Cell(3,1).Range.Text = '��Ʊ��';
DTI.Cell(4,1).Range.Text = '���Ի�';
DTI.Cell(5,1).Range.Text = '�ź�˥������';
DTI.Cell(6,1).Range.Text = '��β';
DTI.Cell(7,1).Range.Text = '��߲�λ';
DTI.Cell(8,1).Range.Text = '����ʱ��';

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
selection.Text =  '����s��ʽ:';
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


% ͼƬ
selection.Text =  '����ͼ';
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



% ����
path = cd;
docname = 'test.docx';
document.SaveAs2([path , docname]);
document.Close