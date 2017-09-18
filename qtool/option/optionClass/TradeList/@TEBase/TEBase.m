classdef TEBase<handle
% TEBase ��ΪTradeList, EntrustList �Ļ��࣬ʵ������һά��
% ����ϡ�����һά�����list
% ����T*p��������ʱ�䣬��������

% ----------------------------------
% ���䳬��20140618��V1.0
% ���䳬��20140725��V2.0����eval���ʽ��
% ���䳬��20140806��V3.0
%   1. ��vecNames�޸�Ϊ headers��
%   2. ��extendTEB, addTEB, pruneTEB�޸�Ϊ extend, add, prune. ��Ӧ��
%       TradeList��EntrustList�е���Щ��������ɾ����
% �̸գ�20140806��V3.1
%   1. ����toTable, toExcel ������ ����ͨ��
% ���䳬��20140807��V3.2
%   1. ����slctByStrategy��slctByItem��slctByInstr��sortByTime��
%       item2vec��vec2item��insertItem��copyItem������
% ���䳬��20140812��V3.2������rmvItem������
% �̸գ�21050527����д���Ѻ����ó�ȥ����һ��ע�ͣ���getCopy()


    %%
    properties
        
        capacity;   % ����¼��Ŀ
        latest;     % ���һ��
        headers;    % �������ƣ���������data
        data;       % ������ʽ������
        instrumentCode;   % ��Լ����,map��ʽ���ṩinstrumentNo��ʵ�ʴ���֮��Ķ�Ӧ��ϵ��
        isSorted;   % ����1�� ���� -1�� ���� 0.
        
        %����ΪN��1������ÿ�����������¼��һ������
        date;       % ���ڣ� matlab ��ʽ�� ��735773
        date2;      % ���ڣ����Σ���20140623
        time;       % ʱ�䣬matlab��ʽ����735773.324
        time2;      % ����ʱ�� HHMMSSFFF
        tick;       % ʱ���Ӧ��tick��
        strategyNo; % ���Ա�ţ�����
        direction;  % ��������buy = 1; sell = -1;
        offSetFlag; % ��ƽ����, open = 1; close = -1;
        volume;     % ����
        price;      % �۸�
        instrumentNo;   % ��Լ���
        orderRef;   % �������
        combNo;     % ��ϱ��
        roundNo;    % �غϱ��
        entrustNo;  % ί�б��
        
        
        % ���࣬���ã���һ���¼�һ��
        specialMark;
    end
    
    
    %% ԭ��д������ĺ���������д������
    methods(Access = 'public', Static = false, Hidden = false)
        [newObj] = slctByInstr(obj,instrNo);
        
        [] = extend(obj,addCapacity);
        
        [] = add(obj,obj2);
        
        % ��ȥ����ռ�
        [] = prune(obj);
        
        %
        [newObj ] = slctByStrategy(obj,sNo)
        
        
        [newObj] = slctByItem(obj,seqNo)
        
        
        [] = sortByTime(obj,mode)
        
        
        [itemVec] = item2vec(obj,seqNo)
        
        
        [] = vec2item(obj,vec,seqNo)
        % seqNo �ǲ���λ�ã�ֻ�����β��롣
        % ������������
        
        [] = insertItem(obj,obj2,seqNo,seqNo2)
        % ��obj2��seqNo2��ȡ�ļ�¼����Ϊһ�����壬���뵽obj��seqNo��
        
        
        [] = copyItem(obj,obj2,seqNo,seqNo2)
        % ��obj2ѡ���ļ�¼copy��obj1��Ӧλ�ã�����ʽ��
        
        
        [] = rmvItem(obj, seqNo)
    end
    
    
    %%
    methods(Access = 'public', Static = false, Hidden = false)
        %% ���캯��������д������
        function obj = TEBase(capacity)
            % ��ʼ��
            if nargin == 0
                capacity = 1000;
            end
            obj.capacity = capacity;
            obj.latest   = 0;
            obj.isSorted = 0;
            obj.headers  = {'date','date2','time','time2',...
                'tick','strategyNo','direction','offSetFlag',...
                'volume','price','instrumentNo','orderRef',...
                'combNo','roundNo','entrustNo','specialMark'};
            
            % data ���б�Ҫ��ʱ����ʹ�ã��˴�������ʼ��
            
            
            for i = 1:length(obj.headers)
                obj.(obj.headers{i}) = zeros(capacity,1);
            end
        end
        
        
        
        % ��Ϊ��handle�࣬��Ҫcopy constructor������ָ�븳ֵ
        [ newobj ]          = getCopy(obj);
        
        % ��������
        
        
        
        
        % �����
        [data, headers] = toTable(obj, headers);
        [ obj ]         = toExcel(obj, filename, sheetname);
    end
    
end

