%% *************************** �������� ****************************
% 2014.5.30��
% �������ݣ����������ݣ����������ʹ�á�

% version 1.0, luhuaibao, 2014.5.30




%% ��ָ�ڻ�����
code = 'IFHot' ;
sd = '20130624' ;
ed = '20130624' ;

 
% ȡ��������
try
    load( [code,'_',sd,'_',ed, '.mat'] ) ;
catch e
    ticks = Fetch.dmTicks(code,sd,ed);
    save( [savePathData,code,'_',sd,'_',ed,'.mat'], 'ticks' ) ;
end ;




% ������Ϣ
nt      = size(ticks.time,1);
nday    = size(unique ( floor(ticks.time) ),1) ;


%% ��ָ�͹�Ʊ����
load( [savePathData, '\tick_data.mat'])

