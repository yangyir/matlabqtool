%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ���������˵���callback��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  changestrategy(popupmenu_Input,strategyexample,handle)

strategy_value = get(popupmenu_Input,'value');
strategyname = strategyexample{strategy_value,1};
strategynameall = strategyexample(:,1);

% ������Ӧ�Ĳ��ԣ�ѡ����Ӧ��������
locate = strcmp(strategyname,strategynameall);
arg = strategyexample(locate,:);
set_display(arg,handle);
end