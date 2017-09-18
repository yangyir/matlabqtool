%% ȡ�������ݡ������ݿ�����
% �ͻ���Ҫ��
% �̸գ�140915


% �Ƿ�����ȡ���ݣ���δ�ı�span��universe��������ȡ��
% 0 - ������load��Ҳ������fetch ����ʡʱ�䣩
% 1 - ����load  ***.mat����ҹ�������棬�������ȴ���ü��׻�����
% 2 - ����dhfetch���иı��Ҫ��������������
switch fetchData1Flag
    
    case {0}
        % 0 - ������load��Ҳ������fetch ����ʡʱ�䣩
        % do nothing
    case {1}
        % 1 - ����load  ***.mat����ҹ�������棬�������ȴ���ü��׻�����
        load data1;
    case {2}
        % 2 - ����dhfetch���иı��Ҫ��������������
%% ʱ����
% sDay = '2014-01-01';
% eDay = '2014-08-30';
dateArr = DH_D_TR_MarketTradingday(1,sDay,eDay);
dateNumArr = datenum(dateArr);
NUMday = size(dateArr,1);

%% ��Ʊuniverse��������ȡ����Ϊ��һ���ı���
% universe = '000300.SH';
% stockArr = DH_E_S_IndexComps(universe,sDay,0);
% stockArr = DH_E_S_SELLTARGET(1,sDay,1);

NUMasset = size(stockArr,1);

%% ��ҵ��Ϣ
% ������ҵ
industry_sw1 = DH_S_INF_SW(stockArr,1,sDay);
industry_sw2 = DH_S_INF_SW(stockArr,2,sDay);
industry_zx1 = DH_S_INF_CITI(stockArr,1,sDay);
industry_zx2 = DH_S_INF_CITI(stockArr,2,sDay);
industry_zjh1 = DH_S_INF_CRSC(stockArr,1,sDay);
industry_zjh2 = DH_S_INF_CRSC(stockArr,2,sDay);

% �Ƿ�Ҫȡһ����ҵmatrix����Ʊ����ҵ�����Ƿ񾭳��仯��
% ��ʱ����������
% ��hs300��������һ�б仯
% tic
% for dt = 1:NUMday
%     tday = dateArr(dt,:);
%     industry_sw1 = DH_S_INF_SW(stockArr,1,tday);
%     for stk = 1:NUMasset
%         indCodeMat(dt,stk) = str2double( industry{stk,1} );
% %         tmp(stk,:) = industry{stk,1};        
%     end    
% %     indCodeMat(dt,:) = str2num(tmp)';
% end
% toc
%% ���ݿ�ȡ����
% 1-����Ȩ; 2-���Ȩ; 3-��ǰ��Ȩ��ȱʡֵΪ3��
fuquan = 3;

% Date *  Asset 
data1.closeMat    = DH_Q_DQ_Stock(stockArr,dateArr,'Close',fuquan)';
data1.openMat     = DH_Q_DQ_Stock(stockArr,dateArr,'Open',fuquan)';
data1.highMat     = DH_Q_DQ_Stock(stockArr,dateArr,'High',fuquan)';
data1.lowMat      = DH_Q_DQ_Stock(stockArr,dateArr,'Low',fuquan)';
data1.avgMat      = DH_Q_DQ_Stock(stockArr,dateArr,'AvgPrice',fuquan)';
data1.volumeMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Volume',fuquan)';
data1.amountMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Amount',fuquan)';
data1.changeMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Change',fuquan)';
data1.retrnMat    = DH_Q_DQ_Stock(stockArr,dateArr,'PCTChange',fuquan)';
data1.tradableMat = double( DH_D_TR_IsTradingDay(stockArr,dateArr)' );%��int32����


% ���������ʣ�����ճ�������ĩ�����õ�������
data1.dretrnMat = data1.closeMat./data1.openMat;
% ֻ���糿���ֵ��������ʣ����ڻز���㣬ֻ���������һ�գ�ȫ����0
data1.retrn2Mat = data1.openMat(2:end,:)./data1.openMat(1:end-1,:) - 1; 
data1.retrn2Mat(end+1,:) = 0;
data1.retrn2Mat(isnan(data1.retrn2Mat)) = 0;


% ����Ȩ�ļ۸񣬹��Ƚ��ã�Ŀ��� �� ʵ�ʼۣ�
fuquan = 1;
data1.closeRTMat  = DH_Q_DQ_Stock(stockArr,dateArr,'Close',fuquan)';
data1.openRTMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Open',fuquan)';
data1.highRTMat   = DH_Q_DQ_Stock(stockArr,dateArr,'High',fuquan)';
data1.lowRTMat    = DH_Q_DQ_Stock(stockArr,dateArr,'Low',fuquan)';
data1.avgRTMat    = DH_Q_DQ_Stock(stockArr,dateArr,'AvgPrice',fuquan)';


save('data1.mat', 'data1', '*Arr', 'industry*','NUM*');
end