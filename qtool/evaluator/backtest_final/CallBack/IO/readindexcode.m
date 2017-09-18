%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڶ�ȡҵ����׼��֤ȯ�����Ȩ��
% ����ҵ����׼������ ��000300.SH�� ��� IndexCode = ��000300.SHI��  weight = 1
% �����ַ�����0.75*000300.SHI+0.25*000001.SHI'  
%����  IndexCode = {��000300.SHI��,��000001.SHI��}
% weight =[0.75;0.25]��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IndexCode,weight] = readindexcode(benchmark)

Index = strfind(benchmark,'+');
IndexCode = cell(length(Index)+1,1);
if isempty(Index)
    IndexCode = cellstr(benchmark);
    weight = 1;
else
    IndexCode{1} = benchmark(1:Index(1)-1);
    for index = 1:length(Index)
        if index == length(Index)
           IndexCode{index+1} = benchmark(Index(index)+1:end); 
        else
           IndexCode{index+1} = benchmark(Index(index)+1:Index(index+1)-1);  
        end
    end
    [weight,IndexCode] = strtok(IndexCode,'*');
    weight = cell2mat(weight);
end


end