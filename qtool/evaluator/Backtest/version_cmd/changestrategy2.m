
function  changestrategy2(popupmenu_Input,strategyexample,handle)

strategy_value = get(popupmenu_Input,'value');
strategyname = strategyexample{strategy_value,1};
strategynameall = strategyexample(:,1);

% 根据相应的策略，选择相应数据样例
locate = strcmp(strategyname,strategynameall);
arg = strategyexample(locate,:);
set_display2(arg,handle);
end