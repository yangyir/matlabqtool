%% ȡ��ǰһ��Ļ���300�ɷֹɺ�Ȩ�أ�����spreadsheet��
% ר�����ifind_qxtl_intradayPrice.xlsx
% ����'ifind_qxtl_DH_weight.xlsx'�� sheet wt_1
% ÿ����������һ��


clear all
rehash


DH
% workingpath = 'V:\root\qtool\onGoing\qxtl';
workingpath = 'D:\tfwork\root\qtool\onGoing\qxtl\';
filename    = 'ifind_qxtl_DH_weight.xlsx';
indexCode   =  '000300.SH';


%%
% �糬�� 15��30��dt=���죬����dt=����
dt = datestr(today, 'yyyy-mm-dd')

% �ɷֹ�
arrCode  = DH_E_S_IndexComps('000300.SH',dt,0);
arrCode2 = DH_S_INF_Abbr(arrCode);

% ����Ȩ�ظ���ǰ���̼ۼ���
arrWt   = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,1);

% dt2     = datestr(today+1, 'yyyy-mm-dd');
% arrWt2  = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,2);

% �����Ƿ�tradable��ʵʱȡ��������0��ֻ����ʷ��ֵ
% stkTradable = DH_D_TR_IsTradingDay(arrCode,dt);

% % ������ͰѲ��ɽ��׵Ķ���ȥ��
% arrCode = arrCode(stkTradable==1);
% arrWt   = arrWt(stkTradable == 1);
% arrWt   = arrWt/ sum(arrWt);  % ���¹�һ��
 

% DH_S_VAL_AdjustTradable(arrCode,'2014-12-15',2)
% DH_S_VAL_MarkertVal(arrCode,'2014-12-15',2)


%% ��¼��excel�У�ר�ŵ�һҳ
xlswrite([workingpath, filename], {dt}, 'wt', 'A1');
xlswrite([workingpath, filename], arrCode, 'wt', 'B1');
xlswrite([workingpath, filename], arrCode2, 'wt', 'C1');
xlswrite([workingpath, filename], arrWt, 'wt', 'D1');
% xlswrite([workingpath, filename], stkTradable, 'wt_1', 'E1');

    
%% ��¼��.mat,����param
% �����Ƿ�tradable��ʵʱȡ��������0��ֻ����ʷ��ֵ
% stkTradable = DH_D_TR_IsTradingDay(arrCode,datestr( datenum(dt)-1 , 'yyyy-mm-dd'));

% ������ͰѲ��ɽ��׵Ķ���ȥ��
% arrCode = arrCode(stkTradable==1);
% arrWt   = arrWt(stkTradable == 1);

save([workingpath '\param\arrCode_' dt '.mat'], 'arrCode');
save([workingpath '\param\arrWt_' dt '.mat'], 'arrWt');

