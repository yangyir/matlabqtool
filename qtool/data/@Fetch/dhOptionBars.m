function [ bs ] = dhOptionBars( optID, start_date, end_date, slice_seconds)
% ȡoption bars, ��Ҫ����DataHouse����ֻ��ȡoption������ȡstock, �ڻ���
% [ bs ] = dhOptionBars( secID, start_date, end_date, slice_seconds, fuquan )
% ���������������DH��������matlab
% �̸գ� 20151219


%% pre
if ~exist('slice_seconds', 'var') 
    slice_seconds = 60;
end


try 
    checklogin;  
catch e
    DH;
end

%% main
bs = Bars;
slicetype   = int32(slice_seconds*100000);
bs.slicetype = slicetype;


% ���ƣ���Ȩ����Ƶ�ʷ�ʱ����
% ��ʽ��DH_Q_HF_OptionIrregSlice(֤ȯ����,��ʼ����,��ֹ����,��ƬƵ��)
% ��������������Ƶ����Ȩ��ʱ���� 
%  ���13��,�ֱ�Ϊ1 ʱ��,2 ǰ����,3 ���̼�,4 ��߼�,5 ��ͼ�,6 ���̼�,7 �ɽ���,
% 8 �ɽ���,9 ����,10 �ֲ����仯,11 �ֲ���,12 �ۼ���߼�,13 �ۼ���ͼ� 
% output = DH_Q_HF_OptionIrregSlice('90000021.SH','2014-03-04','2014-03-10',600)
mat = DH_Q_HF_OptionIrregSlice(optID, start_date, end_date, slice_seconds);


if isempty(mat) 
    error('����no data');
%     return;
end


if sum(sum(isnan(mat))) == size(mat,1)*size(mat,2)
    disp('����no data');
    return;
end

bs.code     = optID;
bs.type     = 'option';
bs.time     = mat(:,1);
bs.open     = mat(:,3);
bs.high     = mat(:,4);
bs.low      = mat(:,5);
bs.close    = mat(:,6);
bs.volume   = mat(:,7);  %
bs.amount   = mat(:,8);
bs.vwap     = mat(:, 9);
bs.openInt  = mat(:, 11);




end

