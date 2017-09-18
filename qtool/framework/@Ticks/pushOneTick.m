function [ obj ] = pushOneTick( obj, onetick )
%PUSHONETICK 向已有Ticks的底部（latest + 1）压入新的一个Tick
% -------------------
% 程刚， 201609， 糙快猛，没有精细处理


%% 检查可压入
if strcmp(obj.code2, onetick.code2) && obj.code ~= onetick.code
    fprintf(2, 'code不同，停止pushOneTick');
    return;
end


%% 逐field压入
cur = obj.latest + 1;


flds = { 'last', 'time', 'time2', 'volume', 'amount', 'tranCnt'};
for i = 1:length(flds)
    fd = flds{i};
    try
    obj.(fd)(cur) = onetick.(fd)(1);
    catch
        fprintf(2,'！出错！%s\n', fd);
    end   
end

% obj.last(cur) = onetick.last(1);
% obj.volume(cur) = onetick.volume(1);
% obj.amount(cur) = onetick.amount(1);
% obj.time(cur) = onetick.time(1);
% obj.time2(cur) = onetick.time2(1);


%%
% L1 = 

flds ={'askP', 'askQ', 'askA', 'bidP', 'bidQ', 'bidA'};

for i = 1:length(flds)
    fld = flds{i};
    try
    obj.(fld)(cur,:) = onetick.(fld);
    catch e
        fprintf(2, '！失败！[pushOneTick] %s', fld);
    end
end
%         
% obj.askP(l,:) = onetick.askP;
% obj.askQ(l,:) = onetick.askQ;
% obj.askA(l,:) = onetick.askA;
% obj.bidP(1,:) = onetick.bidP;
% obj.bidQ(1,:) = onetick.bidQ;
% obj.bidA(1,:) = onetick.bidA;



%%
obj.latest = cur;




end

