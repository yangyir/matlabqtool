function [ bs ] = futureBars( futID, start_date, end_date, slice_seconds)
% ȡ�ڻ�Bars
% �̸գ� 20131210
% luhuaibao, 20140305, DH�����仯��ԭ��10 �ֲ���,11 �ֲ����仯, �֣�11 �ֲ���,10 �ֲ����仯


try 
    checklogin  
catch
    
    DH
end

bs          = Bars;
% Replay��
slicetype   = int32(slice_seconds*100000);


% ���ƣ���Ʒ�ڻ�����Ƶ�ʷ�ʱ����
% ��ʽ��DH_Q_HF_FutureIrregSlice(�ڻ���Լ����,��ʼ����,��ֹ����,��ƬƵ��)
% ��������������Ƶ����Ʒ�ڻ���ʱ����
%  ���13��,�ֱ�Ϊ1 ʱ��,2 ǰ����,3 ���̼�,4 ��߼�,5 ��ͼ�,6 ���̼�,7 �ɽ���,
% 8 �ɽ���,9 ����,10 �ֲ����仯,11 �ֲ���,12 �ۼ���߼�,13 �ۼ���ͼ�
% output = DH_Q_HF_FutureIrregSlice('Cu1206','2012-03-01','2012-03-10',600)
mat = DH_Q_HF_FutureIrregSlice(futID,start_date,end_date,slice_seconds);

bs.code      = futID;
bs.type      = 'future';
bs.slicetype = slicetype;
bs.time      = mat(:,1);
bs.open      = mat(:,3);
bs.high      = mat(:,4);
bs.low       = mat(:,5);
bs.close     = mat(:,6);
bs.amount    = mat(:,8);    %Ԫ
bs.volume    = mat(:,7);    %��
bs.vwap      = mat(:,9);
bs.openInt   = mat(:,11);

end

