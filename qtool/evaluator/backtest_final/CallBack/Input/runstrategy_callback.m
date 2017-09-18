%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ�������а�ť��callback�����в��Եȵ������嵥�����������嵥����
% ����ָ�꣬
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [output,StrategyExample] = runstrategy_callback(h,popupmenu_Input,handle,radio13,handle_push,Configure)

%  �����ɱ�־
plot(h,1);
axis (h,'off');

% set(handle_push(6),'string','ִ�У�busy��');

% ��ȡ������
p3 = get(popupmenu_Input,'value');
strategyname = Configure.StrategyExample{p3,1};

% ��ȡ��ʼ�ͽ�ֹ����
p1 = get(handle(1),'string');
p2 = get(handle(2),'string');
if  datenum(p1) >= datenum(p2)
    errordlg('��ʼ�ձ����ڽ�ֹ��ǰ��');
    output = [];
    return;
end
Configure.StrategyExample{p3,2} = p1;
Configure.StrategyExample{p3,3} = 1;
Configure.StrategyExample{p3,4} = p2;
Configure.StrategyExample{p3,5} = 1;
% ��ȡ��������ֵ�Լ�����
[Configure.StrategyExample{p3,6},Configure.StrategyExample{p3,7},e{1,1}] = inputdata(handle(3),handle(4),handle(5));
[Configure.StrategyExample{p3,8},Configure.StrategyExample{p3,9},e{2,1}] = inputdata(handle(6),handle(7),handle(8));
[Configure.StrategyExample{p3,10},Configure.StrategyExample{p3,11},e{3,1}] = inputdata(handle(9),handle(10),handle(11));
[Configure.StrategyExample{p3,12},Configure.StrategyExample{p3,13},e{4,1}] = inputdata(handle(12),handle(13),handle(14));
[Configure.StrategyExample{p3,14},Configure.StrategyExample{p3,15},e{5,1}] = inputdata(handle(15),handle(16),handle(17));
[Configure.StrategyExample{p3,16},Configure.StrategyExample{p3,17},e{6,1}] = inputdata(handle(18),handle(19),handle(20));

r13 = get(radio13,'value');
%  ���в��� �������嵥
num_var = nargin(strategyname);
order = strcat('''',p1,''',''',p2,'''');
for index = 1:num_var-2
    order = strcat(order,',',e{index,1});
end
order = strcat(strategyname,'(',order,')');
disp('����ִ�в��ԣ���ȴ�...');
[output1,output2,output3] = eval(order);
disp('����ִ�����!��ȴ�...');

% ���������嵥������Ӧָ��
if isempty(output2)
    disp('û�в����κν���');
else
    output = calc_data_display(output1,output2,output3,r13,Configure);
end

% �����������
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
    
disp('ִ�����!');
% ����ִ����ϱ�־
barh(h,1);
text(1,1,'ִ����ϣ�');
axis (h,'off');
% set(handle_push(6),'string','ִ��');
set(handle_push(2:5),'Enable','on');
% msgbox('ִ����ϣ�');

   %  ���ڶ�ȡedit�в���ֵ������radio��Ӧ״̬�����Ĳ�������
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