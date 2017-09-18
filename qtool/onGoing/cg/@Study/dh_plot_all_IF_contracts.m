function [ contracts ] = dh_plot_all_IF_contracts(aimCode, type)
%DH_PLOT_ALL_CONTRACTS �򵥻�: ĳ��Լ�����������к�Լ��ͼ���նȣ�
%     aimCode:    ��ĳ��Լ���� �� IF1406
% �̸գ�140620�����

%% 
if ~exist('type','var'), type = 'Close'; end

%%
edt =  datenum( DH_D_F_FLastDay(aimCode)  );
sdt =  datenum( DH_D_F_FListedDay(aimCode));


%% ��������contacts codes

k = 1;
for yyyy = year(sdt):year(edt)
    for mm = 1:12
        dt4(k) = (yyyy-2000)*100+mm;
        k = k+1;
    end
end

start_dt4   = (year(sdt) - 2000) * 100 + month( sdt );
end_dt4     = (year(edt) - 2000) * 100 + month( edt );
dt4         = dt4( dt4>=start_dt4 & dt4<=end_dt4 );

% ����end_dt֮���3����4��
tmp = DH_E_FS_IF_Contr( datestr(edt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = unique( [dt4,tmp_dt4] ) ;

% ��ȥstart_dt֮ǰ�ģ������У�
tmp =  DH_E_FS_IF_Contr( datestr(sdt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = dt4( dt4>= min(tmp_dt4));

% ����arrCode
for i = 1:length(dt4),  arrCode{i} = ['IF', num2str(dt4(i))]; end


%%
contracts.code  = arrCode';
contracts.edt   = datenum( DH_D_F_FLastDay(  contracts.code) );
contracts.sdt   = datenum( DH_D_F_FListedDay(contracts.code) );

%% ����

datesStr        = DH_D_TR_MarketTradingday(3,datestr(sdt),datestr(edt));

contracts.close = DH_Q_DQ_Future(contracts.code,datesStr,type)';

%% �����к�Լͼ
figure(650); hold off
plot(contracts.close)
legend(arrCode);
title(sprintf('%s�����������еĺ�Լ��%s��%s��', aimCode, datestr(sdt), datestr(edt)) );


end

