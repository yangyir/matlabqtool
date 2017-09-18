function [ obj ] = fromExcel( obj, filename )
% ��excel��csv������󣬴��Matrix2DBase
% ---------------
% �̸գ�20150614��һ���ֲڵ�Ӧ���汾



%% Ԥ����



% ȡ��data�Ĵ�С



%% main
[~, ~, raw] = xlsread(filename);


%% ����У���ȡxProps
xProps = raw(1,2:end);



% ��������֣����string
xProps2 = cell(size(xProps));
for i = 1:length(xProps)
    p = xProps{i};
    if isa( p, 'double'),  
        p_str = num2str( p); 
        xProps2{i} = p_str;
    else
        xProps2{i} = p;
    end
end


%% ����У���ȡyProps
yProps = raw(2:end,1);

% ��������֣����string
yProps2 = cell(size(yProps));
for i = 1:length(yProps)
    p = yProps{i};
    if isa(p, 'double'),  
        p_str = num2str(p); 
        yProps2{i} = p_str;
    else
        yProps2{i} = p;
    end
end




%% ��ȡdata
data1 = raw(2:end, 2:end);
data2 = cell2mat(data1);



%% ����һ��
obj.xProps = xProps2;
obj.yProps = yProps2;
obj.data   = data2;
obj.autoFill;




end

