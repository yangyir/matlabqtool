function [ oi, m2tkCallinfo, m2tkPutinfo ] = init_from_sse_excel( OptInfoXls )
%INIT_FROM_SSE_EXCEL ���Ͻ�������Ȩ�б��г�ʼ�����е�optinfo������һϵ�У���optinfo10000283
% �����Ƕ�ȡ���ļ���OptInfoXls������ļ����ϼ�����վ���أ�ÿ��Ҫ���£�
% ���oi��һϵ��optinfo
% ���m2tkCallinfo, m2tkPutinfo��M2TK�����ָ��oi��optinfo��ָ��
% ԭ��д�ɵ�����script�����ڷ���static����
% -------------------------------------------
% �̸գ�20160121
% ���Ʒ壬20160122������ȡ�ļ���Ϊ��������OptInfoXls
% �̸գ�20160212��yPropsǿ��Ϊcell��datestr������ ��֮ǰ�� [ datenum ] )
% �̸գ�20161018������OptInfo.iT�� OptInfo.iK�� ����������
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
m2tkCallinfo = M2TK( 'call' );
m2tkPutinfo = M2TK( 'put' );

% �ҵ�call��Ӧ����
callLines = strcmp( optinfo( :,3 ) , '�Ϲ�' );
% �ҵ�put��Ӧ����
putLines = strcmp( optinfo( :,3 ) , '�Ϲ�' );

% ȡ��unique K �� unique T�� ����
callOptInfo = optinfo( callLines , : );
putOptInfo = optinfo( putLines , : );

% ������Ȩ��K��T����������
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallinfo.xProps = uniqueK_call';
m2tkCallinfo.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = OptInfo;
m2tkCallinfo.data = data; % �����ݽ��и���

% ������Ȩ��K��T����������
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique( putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutinfo.xProps = uniqueK_put';
m2tkPutinfo.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = OptInfo;
m2tkPutinfo.data = data; % �����ݽ��и���

%% ���OptInfo��M2TK
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
    tmp = OptInfo;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % ���multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % ����optinfo
    varname = ['optinfo',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    oi.(varname) = tmp;
    
    % TODO�� ��tmp ������Ӧ��m2tk��
    switch tmp.CP
        case 'call'
%             posT = find( T == m2tkCallinfo.yProps ); % T��λ��
            posT = find( strcmp( T , m2tkCallinfo.yProps ) ); % T��λ��
            posK = find( abs(  K - m2tkCallinfo.xProps ) < 1e-8 ); % K��λ��
            % ��Ҫ���߷ǿ�
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkCallinfo.data( posT(1), posK(1)  ) = tmp;
            end
        case 'put'
%             posT = find( T == m2tkPutinfo.yProps ); % T��λ��
            posT = find( strcmp( T , m2tkPutinfo.yProps ) ); % T��λ��
            posK = find( abs(  K - m2tkPutinfo.xProps ) < 1e-8 ); % K��λ��
            if ~isempty( posT ) && ~isempty( posK )
                % ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
                m2tkPutinfo.data(  posT(1), posK(1)  ) = tmp;
            end
    end
    
end

%% ��ÿ��OptInfo�������iT�� iK�� ���������ã���Ϊ���е�M2TK����ͬ��ά�ȵ�
[TT, KK ] = size( m2tkCallinfo.data);
for iT = 1:TT
    for iK = 1:KK
        m2tkCallinfo.data(iT, iK).iT = iT;
        m2tkCallinfo.data(iT, iK).iK = iK;
        m2tkPutinfo.data(iT, iK).iT = iT;
        m2tkPutinfo.data(iT, iK).iK = iK;
    end
end


end

