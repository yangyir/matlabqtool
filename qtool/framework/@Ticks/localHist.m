function      [N, X, R, cumR] = localHist(obj, stk, etk, type, grids)
%LOCALHIST ��stk:etk�ֲ���Histogram����������Ͳ���ͼ������hist��
% ��ʽ�� [N, X, R, cumR] = localHist(obj, stk, etk, type, grids)
% ���룺
%     stk, etk    ��ʼ����ֹtick��
%     type        �������ͣ�'last'(Ĭ�ϣ�,'bid','ask'
%     grids       �ָ񻮷֣� Ĭ��Ϊ min : tickValue : max
% �����
%     N           ����
%     X           ����
%     R           ������ȫ��Ϊ1
%     cumR        �ۻ�������X��С����
% ���û��������ͻ�ͼ�����Ż�barh(X, R)
% �̸գ�140802

%% ǰ����
len = length(obj.time);

if ~exist('stk', 'var'), stk = 1; end
if ~exist('etk', 'var')
    if obj.latest > 1
        etk = obj.latest;
    else
        etk = len;
    end
end  

stk     = max(stk,1);
etk     = min(etk,len);

% type
if ~exist('type', 'var'), type = 'last'; end
switch type
    case{'last'}
        px = obj.last(stk:etk);
    case{'bid'}
        px = obj.bidP(stk:etk,1);
    case{'ask'}
        px = obj.askP(stk:etk,1);
    otherwise
        fprintf('���������д�type=%s', type);
        return;
end
       

% grids
if ~exist('grids', 'var')
    mx = max(px);
    mn = min(px);
    step = abs(diff(px));
    step = min( step(step>0) );
    grids = (mn-2*step) : step : (mx+2*step);
end
    



%% main
% try
    [N, X ] = hist(px, grids);    
    
    % �ض�N��X
    l = max( find(N>0, 1, 'first') -1,    1 ) ;
    u = min( find(N>0, 1, 'last' ) +1, length(N)  );
    N = N(l:u);
    X = X(l:u);        
    
    R       = N/sum(N);
    cumR    = cumsum(R);
    
    %% ��ͼ�������û���������
    if nargout == 0    
        barh(X, R);
        title(sprintf('local histogram: %s, tk=%d:%d', type, stk, etk));
    end
    
% catch e
%     fprintf('����%s\n', e.message);
%     return;
% end
end

