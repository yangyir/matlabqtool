function [data, headers, data2] = toTable( obj, headers )
%TOTABLE �������ʱ�����У�����ticks.data, ticks.headers��
% �ɹ����excel�á�Bars��Ҳ��ͬ���ĺ���
% headers�����ȼ�������� > obj.headers > default_headers(��Ҫ�򶼺���
% ===============================================================
% �̸գ�140709
% �̸գ�140801��
%         �֣�date(:,i) = obj.(headers{i});
%         ԭeval( [ 'data(:,i) = obj.' headers{i} ';']  );
%         Ч��û����ߣ�Ҳû����
% �̸գ�140805����ǿ��ǰ�����������headers������ȡobj.headers



%% ǰ����
% ������6����Ҫ
default_headers = {'time', ...
        'time2', ...
        'last', ...
        'volume', ...      
        'amount', ...
        'openInt'};
if size(default_headers, 2) == 1
    default_headers = transpose(default_headers);
end
    
if ~exist('headers', 'var'),  
    if isempty(obj.headers)
        headers = default_headers;
    else
        headers = obj.headers;
    end    
end 
    
%% data    
len     = size(obj.time,1);
data    = nan(len,length(headers));
 
for i = 1:length(headers)
    f = headers{i};
    try
        data(:,i) = obj.(f);
    catch e
        disp( [f '����'] );
    end
end



%% bid, ask ����data����һά��Ҫ����

fields = {'bidP', 'bidV', 'askP', 'askV'};
for ifd = 1:4
    f  = fields{ifd};
    try
        levels = size(obj.(f), 2);
        for ilv = 1:levels
            headers{end+1} = [f num2str(ilv) ];
        end
        data(:, (end+1):(end+levels)) = obj.(f);
    catch e
        fprintf('%s����', f);
    end
end


    

%% data2 ��ű�����Ϣ
fields = {'code','code2','type','levels','latest'};
for i = 1:length(fields)
    f = fields{i};   
    v = obj.(f);
    data2{i,1} = f;
    data2{i,2} = v;
end

i = i+1;
data2{i,1} = 'sdt';
data2{i,2} = datestr(min(obj.time));

i = i+1;
data2{i,1} = 'edt';
data2{i,2} = datestr(max(obj.time));




%% 
obj.data    = data;   
obj.headers = headers;
obj.data2   = data2;



end

