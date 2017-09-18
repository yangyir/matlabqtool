%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������������÷���ָ���һЩ������ҵ����׼���г���׼���޷������ʻ�׼��VaR����ˮƽ
%  ��VaR�Լ�CVaR���㷽����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [benchmark,marketbench,riskfreebench,vara,varmethod] = option_setbenchmark(benchmark,marketbench,riskfreebench,vara,varmethod,path_backtest_configure,type)
if nargin <2
    type = 1;
end

prompt = {'ҵ����׼:','�г���׼:','�޷������ʻ�׼��','VaR����ˮƽ:','VaR�Լ�CVaR���㷽����'};
dlg_title = '���û�׼';
num_lines = 1;
def = ({benchmark,marketbench,riskfreebench,vara,varmethod})';
options.Resize = 'on';
input_arg = inputdlg(prompt,dlg_title,num_lines,def,options);

%  ������Ϊ��ʱ��Ĭ��ֵ
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
        %  ����Ϊ�ı�
        input_arg = cellstr(char(input_arg));
        %  д����ʼ�����ļ���
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