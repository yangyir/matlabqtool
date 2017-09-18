function [bs] = dhBars( secID, startDate, endDate, sliceSeconds, config )
% ��DH��ȡ continuous intraday Bars������DataHouse���������
% [bs] = dhBars( secID, start_date, end_date, slice_seconds, config )
% �Զ�ʶ��֤ȯ���ͣ������ٶ��������Ƽ�ʹ��
% ���ǹ�Ʊ��config.fuquan д����Ȩ��ʽ��1����Ȩ��2��Ȩ��3ǰ��Ȩ
% �̸գ�20131210
% �̸�, 140711��������bug
% �̸գ�20151219��������Ȩ����


%% ��ʼ��

try 
    checklogin;
catch e
    DH;
end


if ~exist('slice_seconds','var'), sliceSeconds = 60; end


% 1 A��,2 B�ɣ�3 H�ɣ�4 ָ����5�۹ɣ�
% 11 ��ͨծȯ��12 ��ת��ծȯ��
% 21 ���ʽ����22 ETF����23 ����ʽ���𣨳�ETF����
% 31 ��ָ�ڻ��� 32 ��Ʒ�ڻ���
% 0 ����֤ȯ  ( option )
% ���������֤ȯ���룬Ϊstring����cell������;
sectype     = GilSecuType(secID);

bs          = Bars;
% % Replay��
% slicetype   = int32(sliceSeconds*100000);


%% 
switch sectype
  
    case {31, 32}
    %% ��ָ�ڻ�����Ʒ�ڻ�
        bs = Fetch.dhFutureBars(secID, startDate, endDate, sliceSeconds);

    case {1,2,3,4,5,21,22,23,12}
    %%����Ʊ���ţԣơ���תծ��12��
       try 
           fuquan = config.fuquan;
       catch e
           fuquan = 1;
       end
         
        bs = Fetch.dhStockBars(secID, startDate, endDate, sliceSeconds, fuquan);
        
    case {0}
        %% 510050.SH��0�� option Ҳ�� 0�� ֻ��
        L = length(secID);
        
        if L == 9  % ��ͬ 510050.SH,  6+3=9        
            bs = Fetch.dhStockBars(secID, startDate, endDate, sliceSeconds, 1);
        elseif L==11   % ��ͬ10000392.SH�� 11λ
            bs = Fetch.dhOptionBars(secID, startDate, endDate, sliceSeconds);
        end

    otherwise
        
        disp('����ʶ��֤ȯ���� ��ʾ����ƱҪ�� .SH .SZ');
        
end

end





