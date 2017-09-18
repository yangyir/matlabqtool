function [ quote, quote_map ] = init_from_excel( futureInfoXls )
%INIT_FROM_SSE_EXCEL ���Ͻ�������Ȩ�б��г�ʼ�����е�quoteOpt������һϵ�У���quoteOpt10000283
% �����Ƕ�ȡ���ļ���OptInfoXls������ļ����ϼ�����վ���أ�ÿ��Ҫ���£�
% ���quote��һϵ��quoteOpt
% ���m2tkCallinfo, m2tkPutinfo��M2TK�����ָ��quote��quoteOpt��ָ��
% ԭ��д�ɵ�����script�����ڷ���static����
% -------------------------------------------
% �̸գ�20160121
% ���Ʒ壬20160122������ȡ�ļ���Ϊ��������OptInfoXls
% �̸գ�20160211,�����չ��QuoteOpt<OptInfo�� �ķ���
% �̸գ�20160212��yPropsǿ��Ϊcell��datestr������ ��֮ǰ�� [ datenum ] )

%% ----------------------------------------------------

if ~exist('futureInfoXls' , 'var')
    futureInfoXls = 'FutureInfo.xlsx';
end

%% ��ȡexcel�ļ�FutureInfo.xlsx(FutureInfoXlsĬ����FutureInfo.xlsx)

[~, ~, futureinfo] = xlsread( futureInfoXls ,'Sheet1');
futureinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , futureinfo ) ) = {''};

%% ����QuoteMap
quote_map = QuoteMap;

%% ���QuoteFuture��QuoteMap
for line = 2 : size(futureinfo,1)
    % ��һ��
    [code,futureName,T] = futureinfo{line,:};
    
    % ���ɣ����
    tmp = QuoteFuture;
    tmp.fillFutureInfo( code, futureName, T);
    
    % ����optinfo
    varname = ['quotefut', code];
    quote.(varname) = tmp;    
    quote_map.add(code, tmp);
end

end

