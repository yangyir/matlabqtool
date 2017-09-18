%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于读取Path路径下策略样例。
% 样例格式如下：
%  MA	 2010-1-1	1 	2010-4-2	1 	000001.SZ	1 	[5,10]	0 	100000	0 	 		 		 	
%  cppi	 2012-2-3	1 	2012-3-3	1 	1000000	0 	900000	0 	3 	0	510050.SH	1 	010107.SH	1 	5	0 
%  第一列为策略名字，后面是策略需要输入的参数以及参数类型（1为字符型，0为数值型）
%  策略样例中可以只有策略名字，而无参数。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  output = readstrategy(Path,type)

if nargin <2
    type =1;
end

if exist(Path,'file') && type == 1
    [~,~,output] = xlsread(Path,'strategy');
else
    Path = strrep(Path,'.xlsx','.mat');
    load(Path);
    output = StrategyExample; 
end
