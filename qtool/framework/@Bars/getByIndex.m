function [ newobj ] = getByIndex(obj, idx)
%GETBYINDEX ������Bars���ó�idx��Ӧ����Ŀ
% �������䣬ֻ��ʱ������ȡidx��Ӧ��
% ������ b = a( a>0 )���÷�
% ���� newtks = tks.getByIndex(tks.last > tks.askP(:,1) )
% ע��bars.latest ������ .data, .data2, .headers����
% �̸գ�20140726
% �̸գ�140829��ʹ�����д����    newobj.(fd)  = obj.(fd);

newobj = Bars;

%% ����fields
flds ={ 'code','code2', 'type', 'slicetype', ... % 'latest', ...
    'date', ...  %'date2', ...
    'preSettlement', 'settlement'};

for i = 1:length(flds)
    fd = flds{i};
    newobj.(fd)  = obj.(fd);
end



%% ʱ������fields
tsFields = {'time', 'time2', ...
    'open', 'high', 'low', 'close', 'vwap', ...
    'volume', 'amount','openInt', ...
    };

for i = 1:length(tsFields)
    fd      = tsFields{i};
    fddata  = obj.(fd);
    if isempty(fddata), continue; end
    if isnan(fddata),   continue; end
    newobj.(fd)  = obj.(fd)(idx,:);

end


end

