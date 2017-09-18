%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于设置风险指标的一些参数。业绩基准、市场基准、无风险利率基准、VaR置信水平
%  和VaR以及CVaR计算方法。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [benchmark,marketbench,riskfreebench,vara,varmethod] = option_setbenchmark(benchmark,marketbench,riskfreebench,vara,varmethod,path_backtest_configure,type)
if nargin <2
    type = 1;
end

prompt = {'业绩基准:','市场基准:','无风险利率基准：','VaR置信水平:','VaR以及CVaR计算方法：'};
dlg_title = '设置基准';
num_lines = 1;
def = ({benchmark,marketbench,riskfreebench,vara,varmethod})';
options.Resize = 'on';
input_arg = inputdlg(prompt,dlg_title,num_lines,def,options);

%  若输入为空时的默认值
if ~isempty( input_arg)
    if isempty( input_arg {1,1})
        input_arg{1,1} = '000300.SHI';
    end
    
    if isempty( input_arg {2,1})
        
        input_arg{2,1} = '000300.SHI';
    end
    
    if isempty( input_arg {3,1})
        input_arg {4,1} = '-1';
    end
    
    if isempty( input_arg {4,1})
        input_arg {4,1} = '0.05';
    end
    
    if isempty( input_arg {5,1})
        input_arg {5,1} = '1';
    end
    
    
    
    if type == 1
        %  设置为文本
        input_arg = cellstr(char(input_arg));
        %  写到初始设置文件中
        xlswrite(path_backtest_configure,input_arg,'RiskIndex','B1:B5');
        benchmark = input_arg {1,1};
        marketbench = input_arg {2,1};
        riskfreebench = input_arg {3,1};
        vara = input_arg {4,1};
        varmethod = input_arg {5,1};
    else
        benchmark = input_arg {1,1};
        marketbench = input_arg {2,1};
        riskfreebench = input_arg {3,1};
        vara = input_arg {4,1};
        varmethod = input_arg {5,1};
        path_backtest_configure = strrep(path_backtest_configure,'.xlsx','.mat');
        save (path_backtest_configure,'benchmark','marketbench','riskfreebench','vara','varmethod','-append');
    end
end



end