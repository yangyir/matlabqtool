%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为策略运行按钮的callback。运行策略等到买卖清单，运用买卖清单计算
% 各类指标，
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [output,StrategyExample] = runstrategy_callback(h,popupmenu_Input,handle,radio13,handle_push,Configure)

%  清除完成标志
plot(h,1);
axis (h,'off');

% set(handle_push(6),'string','执行（busy）');

% 获取策略名
p3 = get(popupmenu_Input,'value');
strategyname = Configure.StrategyExample{p3,1};

% 获取起始和截止日期
p1 = get(handle(1),'string');
p2 = get(handle(2),'string');
if  datenum(p1) >= datenum(p2)
    errordlg('起始日必须在截止日前！');
    output = [];
    return;
end
Configure.StrategyExample{p3,2} = p1;
Configure.StrategyExample{p3,3} = 1;
Configure.StrategyExample{p3,4} = p2;
Configure.StrategyExample{p3,5} = 1;
% 获取其它参数值以及类型
[Configure.StrategyExample{p3,6},Configure.StrategyExample{p3,7},e{1,1}] = inputdata(handle(3),handle(4),handle(5));
[Configure.StrategyExample{p3,8},Configure.StrategyExample{p3,9},e{2,1}] = inputdata(handle(6),handle(7),handle(8));
[Configure.StrategyExample{p3,10},Configure.StrategyExample{p3,11},e{3,1}] = inputdata(handle(9),handle(10),handle(11));
[Configure.StrategyExample{p3,12},Configure.StrategyExample{p3,13},e{4,1}] = inputdata(handle(12),handle(13),handle(14));
[Configure.StrategyExample{p3,14},Configure.StrategyExample{p3,15},e{5,1}] = inputdata(handle(15),handle(16),handle(17));
[Configure.StrategyExample{p3,16},Configure.StrategyExample{p3,17},e{6,1}] = inputdata(handle(18),handle(19),handle(20));

r13 = get(radio13,'value');
%  运行策略 得买卖清单
num_var = nargin(strategyname);
order = strcat('''',p1,''',''',p2,'''');
for index = 1:num_var-2
    order = strcat(order,',',e{index,1});
end
order = strcat(strategyname,'(',order,')');
disp('正在执行策略！请等待...');
[output1,output2,output3] = eval(order);
disp('策略执行完毕!请等待...');

% 根据买卖清单计算相应指标
if isempty(output2)
    disp('没有产生任何交易');
else
    output = calc_data_display(output1,output2,output3,r13,Configure);
end

% 保存策略样例
strategyexampleTemp = Configure.StrategyExample (p3,:);
Configure.StrategyExample(p3,:) = [];
Configure.StrategyExample = [strategyexampleTemp;Configure.StrategyExample];

if  Configure.configurefiletype ==1
    xlswrite(Configure.Path_Strategy_Configure,Configure.StrategyExample,'strategy');
    StrategyExample = Configure.StrategyExample;
else
    StrategyExample = Configure.StrategyExample;
    Configure.Path_Strategy_Configure = strrep(Configure.Path_Strategy_Configure,'.xlsx','.mat');
    save (Configure.Path_Strategy_Configure,'StrategyExample');
end
    
disp('执行完毕!');
% 策略执行完毕标志
barh(h,1);
text(1,1,'执行完毕！');
axis (h,'off');
% set(handle_push(6),'string','执行');
set(handle_push(2:5),'Enable','on');
% msgbox('执行完毕！');

   %  用于读取edit中参数值，根据radio相应状态，更改参数类型
    function  [output1,output2,output3] = inputdata(a,b,c)
        a = get(a,'string');
        b = get(b,'value');
        c = get(c,'value');
        output1 = a;
       
        if b==1 && c ==0
            output3 = strcat('eval(''str2num(''''',a,''''')'')');
            output2 = 0;
        elseif c==1 && b ==0
            if ~isempty(strfind(a,'{'))||~isempty(strfind(a,'['))
                a = strrep(a,'''','''''');
                output3 =strcat('eval(''',a,''')');
            else
                output3 = strcat('''',a,'''') ;
            end
            output2 = 1;
        else
            error('radio error!');
        end
        
    end

end