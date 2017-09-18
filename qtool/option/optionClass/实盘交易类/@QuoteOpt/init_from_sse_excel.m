function [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls )
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
% ���Ʒ� 20170524 ����Multiplier�ͼ�����Ʒ��Ȩ

%% ----------------------------------------------------

if ~exist('OptInfoXls' , 'var')
    OptInfoXls = 'OptInfo.xlsx';
end

%% ��ȡexcel�ļ�OptInfo.xlsx(OptInfoXlsĬ����OptInfo.xlsx)

[~, ~, optinfo] = xlsread( OptInfoXls ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% ����M2TK

% ����call��put������
m2tkCallQuote = M2TK( 'call' );
m2tkPutQuote = M2TK( 'put' );

% �ҵ�call��Ӧ����
callLines = strcmp( optinfo( :,3 ) , '�Ϲ�' );
% �ҵ�put��Ӧ����
putLines = strcmp( optinfo( :,3 ) , '�Ϲ�' );

% ȡ��unique K �� unique T�� ����
callOptInfo = optinfo( callLines, : );
putOptInfo  = optinfo( putLines, : );

% ������Ȩ��K��T����������
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 )  );
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallQuote.xProps = uniqueK_call';
m2tkCallQuote.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = QuoteOpt;
m2tkCallQuote.data = data; % �����ݽ��и���

% ������Ȩ��K��T����������
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutQuote.xProps = uniqueK_put';
m2tkPutQuote.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = QuoteOpt;
m2tkPutQuote.data = data; % �����ݽ��и���

%% ���QuoteOpt��M2TK
colnum = size(optinfo, 2);
for line = 2 : size(optinfo,1)
    
    % ��һ��
    if colnum == 6
        [code,optName,CP,underCode,K,T] = optinfo{line,:};
    else
        [code,optName,CP,underCode,K,T,multiplier] = optinfo{line,:};
        if ischar(multiplier)
            multiplier = str2double(multiplier);
        end
    end
    
    % ���ɣ����
    code = regexp(code, '\.', 'split');
    code = code{1};
    tmp  = QuoteOpt;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % ���multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % ����optinfo
    varname = ['quoteopt',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    quote.(varname) = tmp;
    
    % TODO�� ��tmp ������Ӧ��m2tk��
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallQuote.yProps ) ); % T��λ��
            posK = find( abs(  K - m2tkCallQuote.xProps ) < 1e-8 ); % K��λ��
            % ��Ҫ���߷ǿ�
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkCallQuote.data( posT(1), posK(1)  ) = tmp;
                tmp.iT = posT(1);
                tmp.iK = posK(1);
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutQuote.yProps) ); % T��λ��
            posK = find( abs(  K - m2tkPutQuote.xProps ) < 1e-8 ); % K��λ��
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkPutQuote.data(  posT(1), posK(1)  ) = tmp;
                tmp.iT = posT(1);
                tmp.iK = posK(1);                
            end
    end
    
end

end

