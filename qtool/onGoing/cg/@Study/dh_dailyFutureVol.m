function [ vol, rangePct ] = dh_dailyFutureVol( code, date)
%DH_DAILYFUTUREVOL ��һ���ڻ����ն�vol
% ���ڷ���close����



%% Ϊ�˷���parfor
try 
    checklogin;  
catch e
    DH;
end

%% ȡ���ڼ۸�
% tic
if isa(date, 'double'),  date = datestr(date); end
s = DH_Q_HF_FutureSlice(code, date, 'ClosePrice',1);

% toc
%% �㲨����
% ���ڲ�����
vol      = std(log(s));


% ��֤ vol == stdPricePct ��vol�Ƚ�Сʱ������
% stdPrice    = std(s)
% stdPricePct = std(s)/mean(s)
% error = vol - stdPricePct


rangePct = ( max(s)-min(s) ) / mean(s);

%% ��ͼ
% figure(651); hold off; plot(s); title(sprintf('%s : %s, vol = %0.3f%%',code, date, vol*100) )

end

