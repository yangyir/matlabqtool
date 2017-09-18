function [ contracts ] = dh_plot_all_IF_contracts(aimCode, type)
%DH_PLOT_ALL_CONTRACTS 简单画: 某合约存续期内所有合约的图（日度）
%     aimCode:    “某合约”， 如 IF1406
% 程刚；140620；完成

%% 
if ~exist('type','var'), type = 'Close'; end

%%
edt =  datenum( DH_D_F_FLastDay(aimCode)  );
sdt =  datenum( DH_D_F_FListedDay(aimCode));


%% 生成所有contacts codes

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

% 加上end_dt之后的3个或4个
tmp = DH_E_FS_IF_Contr( datestr(edt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = unique( [dt4,tmp_dt4] ) ;

% 减去start_dt之前的（或许有）
tmp =  DH_E_FS_IF_Contr( datestr(sdt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = dt4( dt4>= min(tmp_dt4));

% 化成arrCode
for i = 1:length(dt4),  arrCode{i} = ['IF', num2str(dt4(i))]; end


%%
contracts.code  = arrCode';
contracts.edt   = datenum( DH_D_F_FLastDay(  contracts.code) );
contracts.sdt   = datenum( DH_D_F_FListedDay(contracts.code) );

%% 数据

datesStr        = DH_D_TR_MarketTradingday(3,datestr(sdt),datestr(edt));

contracts.close = DH_Q_DQ_Future(contracts.code,datesStr,type)';

%% 画所有合约图
figure(650); hold off
plot(contracts.close)
legend(arrCode);
title(sprintf('%s存续期中所有的合约（%s到%s）', aimCode, datestr(sdt), datestr(edt)) );


end

