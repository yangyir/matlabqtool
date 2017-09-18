% 开仓保证金
% 最低标准
% 认购期权义务仓开仓保证金＝[合约前结算价+Max（12%×合约标的前收盘价-认购期权虚值，7%×合约标的前收盘价）] ×合约单位
% 认沽期权义务仓开仓保证金＝Min[合约前结算价+Max（12%×合约标的前收盘价-认沽期权虚值，7%×行权价格），行权价格] ×合约单位
% 维持保证金
% 最低标准
% 认购期权义务仓维持保证金＝[合约结算价+Max（12%×合约标的收盘价-认购期权虚值，7%×合约标的收盘价）]×合约单位
% 认沽期权义务仓维持保证金＝Min[合约结算价 +Max（12%×合标的收盘价-认沽期权虚值，7%×行权价格），行权价格]×合约单位
% 其中，认购期权虚值=Max（行权价-合约标的收盘价，0）
% 认沽期权虚值=max（合约标的收盘价-行权价，0）



% 开仓保证金
callmg = this.preSettle + max( this.S*0.12 - this.M, this.S *0.07)
putmg = min( this.preSettle+ max( this.S*0.12 - this.M,  this.K*0.07), this.K)

% 维持保证金
