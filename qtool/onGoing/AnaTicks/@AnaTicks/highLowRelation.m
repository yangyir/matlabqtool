function  highLowRelation( ticks )
%HIGHLOWRELATION     在command中输出，ticks中的last较bid、last较ask的高低关系
% 一共统计6个量，last=bid, last>bid, last<bid ; last = ask, last>ask, last<ask
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end



if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 


last = ticks.last(1:n);
bid = ticks.bidP(1:n,1);
ask = ticks.askP(1:n,1);


x1 = nnz(last==bid)/n;
x2 = nnz(last<bid)/n;
x3 = nnz(last>bid)/n;
y1 = nnz(last==ask)/n;
y2 = nnz(last>ask)/n;
y3 = nnz(last<ask)/n;

disp(['last==bid 占比: ',num2str(x1)]);
disp(['last<bid 占比: ',num2str(x2)]);
disp(['last>bid 占比: ',num2str(x3)]);
disp(['last==ask 占比: ',num2str(y1)]);
disp(['last>ask 占比: ',num2str(y2)]);
disp(['last<ask 占比: ',num2str(y3)]);
 
end

