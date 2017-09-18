function [ contracts ] = dh_plot_all_IF_contracts2(start_dt, end_dt, type)
%DH_PLOT_ALL_CONTRACTS 简单画一段时间内所有合约的图（日度）
% 
% 程刚；140620；完成

%%  预处理
if ~exist('type','var'), type = 'Close'; end


if start_dt > end_dt
    disp('错误：start_dt < end_dt');
    return
end

%% 生成所有contacts codes
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

% 加上end_dt之后的3个或4个
tmp = DH_E_FS_IF_Contr( datestr(end_dt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = unique( [dt4,tmp_dt4] ) ;

% 减去start_dt之前的（或许有）
tmp =  DH_E_FS_IF_Contr( datestr(start_dt) );
for i =1:4,     tmp_dt4(i) = str2double( tmp{i}(3:6) );  end
dt4 = dt4( dt4>= min(tmp_dt4));

% 化成arrCode
for i = 1:length(dt4),  arrCode{i} = ['IF', num2str(dt4(i))]; end


%% 所有Codes ( 旧，思路清晰，但是慢）
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

%% 数据

datesStr        = DH_D_TR_MarketTradingday(3,datestr(start_dt),datestr(end_dt));

contracts.close = DH_Q_DQ_Future(contracts.code,datesStr,type)';

%% 画所有合约图
figure(650); hold off
plot(contracts.close)
legend(arrCode);
title(sprintf('%s到%s中所有的合约', datestr(start_dt), datestr(end_dt)) );



end

