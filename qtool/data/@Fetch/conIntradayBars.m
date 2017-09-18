function [bs] = conIntradayBars( secID, start_date, end_date, slice_seconds, config )
% ��DH��ȡ continuous intraday Bars
% �Զ�ʶ��֤ȯ���ͣ������ٶ���
% ���ǹ�Ʊ��config.fuquan д����Ȩ��ʽ��1����Ȩ��2��Ȩ��3ǰ��Ȩ
% �̸գ�20131210

%% ��ʼ��

try 
    checklogin;
catch e
    DH;
end


% 1 A��,2 B�ɣ�3 H�ɣ�4 ָ����5�۹ɣ�
% 11 ��ͨծȯ��12 ��ת��ծȯ��
% 21 ���ʽ����22 ETF����23 ����ʽ���𣨳�ETF����
% 31 ��ָ�ڻ��� 32 ��Ʒ�ڻ���0 ����֤ȯ
% ���������֤ȯ���룬Ϊstring����cell������;
sectype     = GilSecuType(secID);

bs          = Bars;
% Replay��
slicetype   = int32(slice_seconds*100000);


%% 
switch sectype
  
    case {31, 32}
% 
%         % ���ƣ���Ʒ�ڻ�����Ƶ�ʷ�ʱ����
%         % ��ʽ��DH_Q_HF_FutureIrregSlice(�ڻ���Լ����,��ʼ����,��ֹ����,��ƬƵ��)
%         % ��������������Ƶ����Ʒ�ڻ���ʱ���� 
%         %  ���13��,�ֱ�Ϊ1 ʱ��,2 ǰ����,3 ���̼�,4 ��߼�,5 ��ͼ�,6 ���̼�,7 �ɽ���,
%         % 8 �ɽ���,9 ����,10 �ֲ���,11 �ֲ����仯,12 �ۼ���߼�,13 �ۼ���ͼ� 
%         % output = DH_Q_HF_FutureIrregSlice('Cu1206','2012-03-01','2012-03-10',600)
%         mat = DH_Q_HF_FutureIrregSlice(secID,start_date,end_date,slice_seconds);
% 
%         bs.code      = secID;
%         bs.type      = 'future';
%         bs.slicetype = slicetype;
%         bs.time      = mat(:,1);
%         bs.open      = mat(:,3);
%         bs.high      = mat(:,4);
%         bs.low       = mat(:,5);
%         bs.close     = mat(:,6);
%         bs.amount    = mat(:,8);
%         bs.volume    = mat(:,7);
%         bs.vwap      = mat(:,9);
%         bs.openInt   = mat(:,11);
        
        bs = Fetch.futureBars(secID, start_date, end_date, slice_seconds);

    case {1,2,3,4,5,21,22,23}
       %%
       try 
           fuquan = config.fuquan;
       catch e
           fuquan = 1;
       end
       
       
%         % SecuCode:char/cell,��֧���������롣��Ʊ�������Ӧ��׺����ƱΪ.SH/ .SZ
%         % StartDate:numeric/char/cell,��֧���������롣����ΪMATLAB��ʶ������
%         % EndDate:numeric/char/cell,��֧���������롣����ΪMATLAB��ʶ������
%         % IR:numeric����Ȩ��ʽ��1Ϊ����Ȩ��2Ϊ���Ȩ��3Ϊ��ǰ��Ȩ
%         % Slice:numeric����λΪ�룬ȱʡֵΪ1��
%         % ���������ز�������Ƭ���ݡ�������:
%         % 1,����ʱ��(BargainTime);2,ǰ���̼�(PrevClosePrice);3,���̼�(OpenPrice)
%         % 4,��߼�(HighPrice);5,��ͼ�(LowPrice);6,���̼�(ClosePrice);
%         % 7,�ɽ���(BargainAmount);8,�ɽ����(BargainSum);9,�ɽ�����(TurnoverDeals);
%         % 10,����(AvgPrice);11,�ۼ���߼�(AccuHighPrice);12,�ۼ���ͼ�(AccuLowPrice)��
%         mat = DH_Q_HF_StockIrregSlice(secID, start_date, end_date, fuquan, slice_second);
%         
%         bs.code     = secID;
%         bs.type     = 'stock';
%         bs.slicetype = slicetype;
%         bs.time     = mat(:,1);
%         bs.open     = mat(:,3);
%         bs.close    = mat(:,6);
%         bs.high     = mat(:,4);
%         bs.low      = mat(:,5);
%         bs.amount   = mat(:,8);
%         bs.volume   = mat(:,7);
        
        bs = Fetch.stockBars(secID, start_date. end_date, slice_seconds, fuquan);
    otherwise
        
        disp('����ʶ��֤ȯ���� ��ʾ����ƱҪ�� .SH .SZ');
        
end

end





