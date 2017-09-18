function [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan )
% ȡstock bars, ��Ҫ����DataHouse����ֻ��ȡstock��etf��ָ���ȣ�����ȡ�ڻ���
% [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan )
% ���������������DH��������matlab
% �̸գ� 20131210


%% ǰ����
if ~exist('slice_seconds', 'var') 
    slice_seconds = 60;
end

if ~exist('fuquan', 'var')
    fuquan = 1;
end


try 
    checklogin;  
catch e
    DH;
end

%% main

bs          = Bars;
% Replay��
slicetype   = int32(slice_seconds*100000);


% SecuCode:char/cell,��֧���������롣��Ʊ�������Ӧ��׺����ƱΪ.SH/ .SZ
% StartDate:numeric/char/cell,��֧���������롣����ΪMATLAB��ʶ������
% EndDate:numeric/char/cell,��֧���������롣����ΪMATLAB��ʶ������
% IR:numeric����Ȩ��ʽ��1Ϊ����Ȩ��2Ϊ���Ȩ��3Ϊ��ǰ��Ȩ
% Slice:numeric����λΪ�룬ȱʡֵΪ1��
% ���������ز�������Ƭ���ݡ�������:
% 1,����ʱ��(BargainTime);2,ǰ���̼�(PrevClosePrice);3,���̼�(OpenPrice)
% 4,��߼�(HighPrice);5,��ͼ�(LowPrice);6,���̼�(ClosePrice);
% 7,�ɽ���(BargainAmount);8,�ɽ����(BargainSum);9,�ɽ�����(TurnoverDeals);
% 10,����(AvgPrice);11,�ۼ���߼�(AccuHighPrice);12,�ۼ���ͼ�(AccuLowPrice)��
mat = DH_Q_HF_StockIrregSlice(secID, start_date, end_date, fuquan, slice_seconds);

% if isnan(mat)
%     disp('����no data');
%     return;
% end

if isempty(mat) 
    disp('����no data');
    return;
end

if sum(sum(isnan(mat))) == size(mat,1)*size(mat,2)
    disp('����no data');
    return;
end


bs.code     = secID;
bs.type     = 'stock';
bs.slicetype = slicetype;
bs.time     = mat(:,1);
bs.open     = mat(:,3);
bs.close    = mat(:,6);
bs.high     = mat(:,4);
bs.low      = mat(:,5);
bs.amount   = mat(:,8);     %Ԫ
bs.volume   = mat(:,7);     %��
        

end

