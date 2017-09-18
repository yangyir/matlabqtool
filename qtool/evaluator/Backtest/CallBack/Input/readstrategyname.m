%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于生成策略下拉菜单popupmenu_Input的字符串
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = readstrategyname(strategyexample)

output = strategyexample{1,1};
for index = 1:size(strategyexample,1)-1
    output = strcat(output,'|',strategyexample{index+1,1});
end


end



