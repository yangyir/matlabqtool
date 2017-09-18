
function [ m2tkCallMarginRate , m2tkPutMarginRate ] = calc_margin_rate( OptInfoXls , w )
%����margin_rate������ask��bid������margin_rate
%���Ʒ壬20160217
% ����
%OptInfoXls�������xlsx������
%w��windmatlab�Ľӿڵ�API
%DEMO
% w = windmatlab;
% [ CallMarginRate , PutMarginRate ] = QuoteOpt.calc_margin_rate( 'OptInfo.xlsx' , w );

if ~exist('OptInfoXls' , 'var')
    OptInfoXls = 'OptInfo.xlsx';
end

if ~isobject( w )
    return;
end

%% ��ȡexcel�ļ�OptInfo.xlsx(OptInfoXlsĬ����OptInfo.xlsx)

[~, ~, optinfo] = xlsread( OptInfoXls ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% ����M2TK

% ����call��put������
m2tkCallQuote = M2TK( 'call' );
m2tkPutQuote  = M2TK( 'put' );

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
m2tkCallQuote.xProps = uniqueK_call';
m2tkCallQuote.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = QuoteOpt;
m2tkCallQuote.data = data; % �����ݽ��и���

% ������Ȩ��K��T����������
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
m2tkPutQuote.xProps = uniqueK_put';
m2tkPutQuote.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = QuoteOpt;
m2tkPutQuote.data = data; % �����ݽ��и���

m2tkCallSel = false( nT , nK );
m2tkPutSel  = false( nT , nK );

%% ���QuoteOpt��M2TK

for line = 2 : size(optinfo,1)
    
    % ��һ��
    [code,optName,CP,underCode,K,T] = optinfo{line,:};
    code = str2double(code(1:8));
    if isa(underCode, 'char')
        underCode = str2double(underCode);
    end
    
    % ���ɣ����
    tmp = QuoteOpt; %OptInfo;
    tmp.fillOptInfo( code, optName, underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % TODO�� ��tmp ������Ӧ��m2tk��
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallQuote.yProps ) ); % T��λ��
            posK = find( abs(  K - m2tkCallQuote.xProps ) < 1e-8 ); % K��λ��
            % ��Ҫ���߷ǿ�
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkCallQuote.data( posT(1), posK(1)  ) = tmp;
                m2tkCallSel( posT(1), posK(1)  )        = true;
                % �������������
                m2tkCallQuote.data( posT(1), posK(1)  ).fillQuoteWind( w );
                % ����Ѿ���ȡ������������
                str_Call = m2tkCallQuote.data( posT(1), posK(1)  ).infoLongstr;
                str_Call = sprintf( '%s �����Ѿ���ȡ���....' , str_Call );
                disp( str_Call )
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutQuote.yProps) ); % T��λ��
            posK = find( abs(  K - m2tkPutQuote.xProps ) < 1e-8 ); % K��λ��
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkPutQuote.data(  posT(1), posK(1)  ) = tmp;
                m2tkPutSel( posT(1) , posK(1) )         = true;
                % ���������������
                m2tkPutQuote.data( posT(1) , posK(1) ).fillQuoteWind( w );
                % ����Ѿ���ȡ������������
                str_Put = m2tkPutQuote.data( posT(1) , posK(1) ).infoLongstr;
                str_Put = sprintf( '%s �����Ѿ���ȡ���....' , str_Put );
                disp( str_Put )
            end
    end
    

end

%% ������ݽ������margin rate

CallMarginRate = nan( nT , nK );
PutMarginRate  = nan( nT , nK );

for i = 1:nT
    for j = 1:nK
        if m2tkCallSel( i , j )
            CallMarginRate( i , j ) = m2tkCallQuote.data( i , j ).calcMarginRate_bid;
        end
        if m2tkPutSel( i , j )
            PutMarginRate( i , j ) = m2tkPutQuote.data( i , j ).calcMarginRate_bid;
        end
    end
end

m2tkCallMarginRate = m2tkCallQuote.getCopy;
m2tkPutMarginRate  = m2tkPutQuote.getCopy;

m2tkCallMarginRate.data = CallMarginRate;
m2tkPutMarginRate.data  = PutMarginRate;

end

%% ---------------EOF-----------------
