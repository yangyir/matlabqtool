function [ bs ] = stockBars( secID, start_date, end_date, slice_seconds, fuquan )
% ȡstock bars
% �̸գ� 20131210


if nargin < 5
    fuquan = 1;
end


if checklogin  == 0
    DH
end



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

