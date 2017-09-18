%% 初始化一些列m2TK矩阵
% vol
m2tk = Matrix2DBase;
m2tk.des2 = '市场上的期权的T，K二维数组';
m2tk.xLabel = 'T到期日';
m2tk.xProps = uTs;
m2tk.yLabel = 'K执行价';
m2tk.yProps = uKs';

call.code = m2tk.getCopy;
call.ask1 = m2tk.getCopy;
call.bid1 = m2tk.getCopy;
call.ask1vol = m2tk.getCopy;
call.bid1vol = m2tk.getCopy;
call.ask1q = m2tk.getCopy;
call.bid1q = m2tk.getCopy;
put.code = m2tk.getCopy;
put.ask1 = m2tk.getCopy;
put.bid1 = m2tk.getCopy;
put.ask1vol = m2tk.getCopy;
put.bid1vol = m2tk.getCopy;
put.ask1q = m2tk.getCopy;
put.bid1q = m2tk.getCopy;

call.profptr = m2tk.getCopy;
put.profptr = m2tk.getCopy;

%% 写入合约代码
m2c = call.code;
m2c.des = 'call的代码';
m2c.datatype = 'string cell';
d1 = cell(length(uTs), length(uKs));
m2p = put.code;
m2p.des = 'put的代码';
m2p.datatype = 'string cell';
d2 = cell(length(uTs), length(uKs));

for i = 1:L
    code = data{i,1};  % 10000100.SH
    code2 = code(1:8); % 10000100
    if icCP(i) == 1 % 沽
        d2{icT(i), icK(i) } = code2;
    elseif icCP(i) == 2 % 购
        d1{icT(i), icK(i) } = code2;
    end    
end

m2c.data = d1;
m2p.data = d2;

%% 把指向profile的指针放进去
m2c = call.profptr;
m2c.des = 'call的profile的指针';
m2p = put.profptr;
m2p.des = 'put的profile的指针';
m2c.data = cell(length(uTs), length(uKs));
m2p.data = cell(length(uTs), length(uKs));

for i = 1:L
    code = data{i,1};  % 10000100.SH
    code2 = code(1:8); % 10000100
    profileVarName = ['l2prof.sh', code2];
    if icCP(i) == 1 % 沽
        try
            eval(  [ ' m2p.data{icT(i), icK(i) } = ' profileVarName ';'] );
        catch e
            m2p.data{icT(i), icK(i) } = nan;
        end
    elseif icCP(i) == 2 % 购
        try
            eval(  [ ' m2c.data{icT(i), icK(i) } = ' profileVarName ';'] );
        catch e
            m2c.data{icT(i), icK(i) } = nan;
        end
            
    end    
end
