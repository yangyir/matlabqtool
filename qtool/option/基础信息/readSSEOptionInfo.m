% %
% 1, copy 上交所当日合约信息只txt，xlsx
% 2，运行此script读入，可转存成.m，储存


path = 'D:\qtools\qtool\option\基础信息\上交所当日合约信息\';
fn = '151113';
fntxt = [fn, '.txt'];

txtin = importdata( [path, fntxt] );

L = size(txtin,1); %行数
C = size(regexp(txtin{1},'\t', 'split'),2); %列数，16
% 输出的cell
outTable = cell(L, C);
for i = 1:L
    l = regexp(txtin{i},'\t', 'split');
    for j = 1:C
        outTable{i,j} = l{j};
    end
    
    oinfo = OptionInfo;
    oinfo.readSSEdailyInfo(txtin{i});
end

% 储存
save([path, fn] , 'outTable');



%% meta infomation
[Ts, ia, ic]    = unique(str2double(outTable(2:end, 10)));
[Ks, ia2, ic2]  = unique(str2double(outTable(2:end, 6)));

m2contractCode = Matrix2DBase;
m2contractCode.des = '市场上的期权的T，K二维数组';
m2contractCode.xLabel = 'T到期日';
m2contractCode.xProps = Ts;
m2contractCode.yLabel = 'K执行价';
m2contractCode.yProps = Ks';

m2contractCode.datatype = 'cell of string';
m2contractCode.data = {};

% 这个矩阵储存合约的序号，供引用时用
m2contractIdx = m2contractCode.getCopy;
m2contractIdx.des = '期权合约的线性编码';
m2contractCode.datatype = 'number';

for jj = 1:L-1
    m2contractCode.data(ic(jj), ic2(jj)) = outTable(jj+1, 1);
    m2contractIdx.data(ic(jj), ic2(jj) ) = jj+1;
end


contractCode = oinfo.contractCode
contractCode = outTable{2:end, 1}
containers.Map( {  } , ic);



% uniqueTs = 


i = 3;

str = outTable{i,3};
% 50ETF沽12月2150






