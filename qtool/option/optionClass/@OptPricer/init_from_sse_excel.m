function [ pricer , m2tkCallPricer, m2tkPutPricer ] = init_from_sse_excel( optInfoxlsx )
%INIT_FROM_SSE_EXCEL ���Ͻ�������Ȩ�б��г�ʼ�����е�optpricer������һϵ�У���optPricer10000283
% �����Ƕ�ȡ���ļ���OptInfoXls������ļ����ϼ�����վ�����ȡ��ÿ��Ҫ���£�
% ���pricer��һϵ��OptPricer
% ���m2tkCallinfo, m2tkPutinfo��M2TK�����ָ��pricer��OptPricer��ָ��
%DEMO
% [ pricer , m2tkCallPricer, m2tkPutPricer ] = OptPricer.init_from_sse_excel;
% -------------------------------------------
% �̸գ�20160121
% ���Ʒ壬20160122������ȡ�ļ���Ϊ��������OptInfoXls
% �̸գ�20160212��yPropsǿ��Ϊcell��datestr������ ��֮ǰ�� [ datenum ] )
% ���Ʒ壬20160229���޸�Ϊ��ȡPricer�ķ���
% ���Ʒ� 20170524 ����Multiplier�ͼ�����Ʒ��Ȩ

%% ----------------------------------------------------

if ~exist('optInfoxlsx' , 'var')
    optInfoxlsx = 'OptInfo.xlsx';
end

%% ��ȡexcel�ļ�OptInfo.xlsx(OptInfoXlsĬ����OptInfo.xlsx)

[~, ~, optinfo] = xlsread( optInfoxlsx ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% ����M2TK

% ����call��put������
m2tkCallPricer = M2TK( 'call' );
m2tkPutPricer  = M2TK( 'put' );

% �ҵ�call��Ӧ����
callLines = strcmp( optinfo( :,3 ) , '�Ϲ�' );
% �ҵ�put��Ӧ����
putLines  = strcmp( optinfo( :,3 ) , '�Ϲ�' );

% ȡ��unique K �� unique T�� ����
callOptInfo = optinfo( callLines, : );
putOptInfo  = optinfo( putLines, : );

% ������Ȩ��K��T����������
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 )  );
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallPricer.xProps = uniqueK_call';
m2tkCallPricer.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = OptPricer;
m2tkCallPricer.data = data; 

% ������Ȩ��K��T����������
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutPricer.xProps = uniqueK_put';
m2tkPutPricer.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = OptPricer;
m2tkPutPricer.data = data; 

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
    tmp = OptPricer;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % ���multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % ����optinfo
    varname = ['optpricer',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    pricer.(varname) = tmp;
    
    % TODO�� ��tmp ������Ӧ��m2tk��
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallPricer.yProps ) ); % T��λ��
            posK = find( abs(  K - m2tkCallPricer.xProps ) < 1e-8 ); % K��λ��
            % ��Ҫ���߷ǿ�
            if ~isempty( posT ) && ~isempty( posK )
                m2tkCallPricer.data( posT(1), posK(1)  ) = tmp;
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutPricer.yProps) ); % T��λ��
            posK = find( abs(  K - m2tkPutPricer.xProps ) < 1e-8 ); % K��λ��
            if ~isempty( posT ) && ~isempty( posK )
                m2tkPutPricer.data(  posT(1), posK(1)  ) = tmp;
            end
    end
    
end



end

