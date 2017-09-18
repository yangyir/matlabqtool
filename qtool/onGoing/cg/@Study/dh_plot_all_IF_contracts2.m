function [ contracts ] = dh_plot_all_IF_contracts2(start_dt, end_dt, type)
%DH_PLOT_ALL_CONTRACTS �򵥻�һ��ʱ�������к�Լ��ͼ���նȣ�
% 
% �̸գ�140620�����

%%  Ԥ����
if ~exist('type','var'), type = 'Close'; end


if start_dt > end_dt
    disp('����start_dt < end_dt');
    return
end

%% ��������contacts codes
k = 1;
for yyyy = year(start_dt):year(end_dt)
    for mm = 1:12
        dt4(k) = (yyyy-2000)*100+mm;
        k = k+1;
    end
end

start_dt4   = (year(start_dt) - 2000) * 100 + month( start_dt );
end_dt4     = (year(end_dt) - 2000) * 100 + month( end_dt );
dt4         = dt4( dt4>=start_dt4 & dt4<=end_dt4 );

% ����end_dt֮���3����4��
tmp = DH_E_FS_IF_Contr( datestr(end_dt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = unique( [dt4,tmp_dt4] ) ;

% ��ȥstart_dt֮ǰ�ģ������У�
tmp =  DH_E_FS_IF_Contr( datestr(start_dt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = dt4( dt4>= min(tmp_dt4));

% ����arrCode
for i = 1:length(dt4),  arrCode{i} = ['IF', num2str(dt4(i))]; end


%% ����Codes ( �ɣ�˼·��������������
% k = 1;
% arrCode ={};
% for yy = 10:14
% for mm = 1:12
%     tmp = yy*100+mm;
%      code = ['IF', num2str(tmp)];
%      issDateStr  = DH_D_F_FListedDay( code );
%      if isempty(issDateStr{1})
%          continue;
%      end
%      arrCode{k} = code;
%      k = k+1;
% end
% end

%%
contracts.code  = arrCode';
contracts.edt   = datenum( DH_D_F_FLastDay(  contracts.code) );
contracts.sdt   = datenum( DH_D_F_FListedDay(contracts.code) );

%% ����

datesStr        = DH_D_TR_MarketTradingday(3,datestr(start_dt),datestr(end_dt));

contracts.close = DH_Q_DQ_Future(contracts.code,datesStr,type)';

%% �����к�Լͼ
figure(650); hold off
plot(contracts.close)
legend(arrCode);
title(sprintf('%s��%s�����еĺ�Լ', datestr(start_dt), datestr(end_dt)) );



end

