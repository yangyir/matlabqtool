classdef TradeList<TEBase
%TRADELIST ��¼�ɽ���Ϣ
% ������¼Ӧ����ʱ��˳�򣬴�С��������

% ------------------------------
% ���䳬��20140618��V.10
% ���䳬��20140701��V2.0
%   1.�����������������
% ���䳬��20140710��V3.0
%   1.����insertItem������
%   2.����copyItem������
% ���䳬��20140725��V4.0
%   1. ����headers����ΪTradeList�������������ͷ��
%   2. ������toTable, toExcel ������
%   3. ��eval�����޸�Ϊ�����ʽ��
%   4. ���뽻��ר������ updCPPItem
% ���䳬��20140806��V5.0
%   1. ɾ��headers�����Ѿ���TEBase�д��ڡ�
%   2. ɾ��TLVecNames��
%   3. �޸Ĺ��캯��TradeList
%   4. delete extend();
%   5. delete prune();
%   6. delete add();
% �̸գ�140806��V5.1
%   1. ��toTable��toExcel�����Ƶ�����TEBase��
% ���䳬��20140807��V5.2
%   1. ��slctByStrategy��slctByItem��slctByInstr��sortByTime��
%      item2vec��vec2item��insertItem��copyItemǨ�Ƶ�TEBase��
% ���䳬��20140812��V5.2
%   1. ����addNewItem ������
%   1. ����filterLocalTrade������
% ���䳬��20140814��V5.3
%   1. ������genReportTable��reAdjustOpenClose����������ձ�ʱʹ�á�
% ���䳬��20140918��V6.0
%   1. ɾ����updCPPItem������
% �̸գ�20150527���Ѻ����Ƶ�����
    
    %%
    properties
        % ���¾�ΪN��1����
        % �ɽ����
        tradeID;
    end
    
    %%
    methods
        function obj = TradeList(capacity)
            % ���䳬��20140806��V2.0
            %   1. �޸ĳ�ʼ����ʽ,�����ĳ�ʼ������ͨ��������ɡ�
            
            if nargin == 0
                capacity = 1000;
            end
            
            obj.capacity = capacity;
            obj.headers = [obj.headers, {'tradeID'}];
            
            for i = 1:length(obj.headers)
                obj.(obj.headers{i}) = zeros(capacity,1);
            end
        end
        
    end
    
    %% ����ר��
    methods
        
        % �¼�һ��
        addNewItem(obj,newTrade);
        
        filterLocalTrade(obj);
        
        [reportTable] = genReportTable(obj,instrument)
        % Ϊ��������б��ձ�
        [] = reAdjustOpenClose(obj)
        % ���µ�����ƽ
        
        
        
    end
    
end