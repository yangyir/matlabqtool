%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于输出交易清单。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [output] = calc_buysellpoint(bars,account,volume,configure)
%%
dPos = volume(:,2);
position = cumsum(dPos);
len = length(position);
oprnIndex = find(dPos);
oprnIndex = [1;oprnIndex];
if oprnIndex(end)~=len
    oprnIndex = [oprnIndex;len];
end
closePrice = bars.close;
oprnPrice = bars.open;
dates = bars.time;
multiplier = configure.multiplier;
%%
equity = closePrice.*position*multiplier;
cash = account-equity;
oprnAmount = -dPos.*bars.open;

oprnList = [oprnAmount,cash,dPos,oprnPrice,position,account];
oprnList = oprnList(oprnIndex,:);
dates = dates(oprnIndex);
dates = datestr(dates);
oprnList = [cellstr(dates),num2cell(oprnList)];

listTitle = {'Date';'Trade Amount';'Cash';'Trade Volume';'Trade Price'; 'Position'; 'Net Value'};

output = {oprnList,listTitle};

end