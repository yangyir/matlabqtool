%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������������ɲ��������˵�popupmenu_Input���ַ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = readstrategyname(strategyexample)

output = strategyexample{1,1};
for index = 1:size(strategyexample,1)-1
    output = strcat(output,'|',strategyexample{index+1,1});
end


end



