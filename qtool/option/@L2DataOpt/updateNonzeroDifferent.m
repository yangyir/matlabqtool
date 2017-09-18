function [ obj ] = updateBid( obj, origin )
%UPDATEbid ��origin�еķ�0����nan����obj��ͬ�����ֵ��ע��obj
% �̸գ�151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%% ����L2����
flds = {
       'quoteTime';%     ����ʱ��(s)
       'dataStatus';%    DataStatus	
       'secCode';%֤ȯ����	
       'accDeltaFlag';%ȫ��(1)/����(2)	
       'preSettle';%���ս����	
       'settle';%���ս����	
       'open';%���̼�	
       'high';%��߼�	
       'low';%��ͼ�	
       'last';%���¼�	
       'close';%���̼�	
       'refP';%��̬�ο��۸�	
       'virQ';%����ƥ������	
       'openInt';%��ǰ��Լδƽ����	

       'askQ1';%������1	
       'askP1';%������1	
       'askQ2';%������2	
       'askP2';%������2	
       'askQ3';%������3	
       'askP3';%������3	
       'askQ4';%������4	
       'askP4';%������4	
       'askQ5';%������5	
       'askP5';%������5	
       'bidQ1';%������1	
       'bidP1';%������1	
       'bidQ2';%������2	
       'bidP2';%������2	
       'bidQ3';%������3	
       'bidP3';%������3	
       'bidQ4';%������4	
       'bidP4';%������4	
       'bidQ5';%������5	
       'bidP5';%������5
       
       'volume';%�ɽ�����
       'amount';%�ɽ����	
       'rtflag';%��Ʒʵʱ�׶α�־	
       'mktTime';%�г�ʱ��(0.01s)
        };

% flds    = fields( obj );
for i = 1:length(flds)
    fd  = flds{i};
    
    tmp = origin.(fd);
    
    % ���Ϊ�ա���0��û�仯������
    if isnan(tmp),  continue, end;
    if isempty(tmp), continue, end;
    if tmp == 0, continue,  end;
    try 
        if obj.(fd) == tmp
            continue, 
        end;
    catch
        if strcmp(obj.(fd), tmp) 
            continue;
        end
    end
    
    % ����
    obj.(fd) = tmp;
    
    % ��¼������
    if i == 1, continue, end;
    obj.changedL2fields{end+1} = fd;
end    

% ��¼�����ı����
obj.changedL2fields = unique(obj.changedL2fields);


end

