function [ vol, rangePct] = dh_dailyStockVol( code, date)
%DH_DAILYFUTUREVOL ��һ���ڻ����ն�vol
% ���ڷ���close����


%% Ϊ�˷���parfor
try 
    checklogin;  
catch e
    DH;
end



%% ȡ���ڼ۸�
% �۸�
% tic
if isa(date, 'double'),  date = datestr(date); end

s = DH_Q_HF_StockSlice(code, date, 'ClosePrice',1);
% toc
%% �㲨����
% ���ڲ�����
vol      = std(log(s));

% stdPrice    = std(s)
% stdPricePct = std(s)/mean(s)
% ��֤ vol == stdPricePct ��vol�Ƚ�Сʱ������
% error = vol - stdPricePct


% range
rangePct = ( max(s)-min(s) ) / mean(s);


%% ��ͼ
% figure(651); hold off; plot(s); title(sprintf('%s : %s, vol = %0.3f%%',code, date, vol*100) )

end

