function [ uniCodesAll, dtsCell ] = dhIndexCompsAlltime( indexCode, sdt, edt )
%����һ��ָ����ĳ��ʱ��������еĳɷֹɣ����������ģ���ʹ��DH
% [ uniCodesAll, dtsCell ] = dhIndexCompsAlltime( indexCode, sdt, edt )
%     indexCode�� ָ�����룬Ĭ��'000300.SH'
%     sdt����ʼ�գ�matlabʱ��ʵ����Ĭ��Ϊ֤ȯ������
%     edt�������գ�matlabʱ��ʵ����Ĭ��today
%     uniCodesAll�����гɷֹɴ���
%     dtsCell�� �����գ�cell��ʽ��û��Ҫ����������
% --------------
% �̸գ�2015-5-15������

%% Ԥ����
if ~exist('indexCode', 'var')
    indexCode = '000300.SH'; %����300
    % indexCode = '000016.SH';  %��֤50
end

if ~exist('sdt','var')
    sdt = datenum(2015,1,1);
    sdt = DH_D_OTH_ListedDay(indexCode)
end

if ~exist('edt','var')
    edt = today;
end



%% main
% ָ�����������
% indexName = DH_S_INF_Abbr(indexCode);

% ʱ���
% dts = DH_D_TR_MarketTradingday(1,sdt, edt);
dts = DH_D_TR_SecurityTradingday(indexCode, sdt, edt, 0);
dts = dts(1:20:end, :);

dtsCell = cell(size(dts,1),1);
for i = 1:size(dts,1)
    dtsCell{i,1} = dts(i,:);
end

%% ���й�Ʊ����Ĳ���
codesAll = {};

for idt = 1:size(dts,1)
    dtStr = dts(idt,:);
    codes = DH_E_S_IndexComps(indexCode, dtStr,0);
    
    % �ϲ�
    for ic = 1:length(codes)
        codesAll{end+1,1} = codes{ic};
    end  
end

% ȡunique
uniCodesAll = unique(codesAll);

end

