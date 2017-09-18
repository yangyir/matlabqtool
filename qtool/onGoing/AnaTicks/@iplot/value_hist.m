function [ h1, h2 ] = value_hist( vector, times, tickvalue )
%VALUE_HIST ��ͼvalue����ͼ����hist����ͼ������ͳһ
% vector          ��ֵ���У�Y�ᣩ
% times           ʱ��ֵ���У�X�ᣩ,Ĭ����1:length(vector)
% tickvalue       ��histʱ�ļ�����粻�������
% h1, h2          subplot handles
% �̸գ�140611


%% Ԥ����
if ~exist('times', 'var'), times = 1:length(vector); end

if size(vector,2) > 2, 
    disp('���棺vector����2������ȡ��һ�еڶ���');
    vector = vector(:,1:2); 
end

mx = max(max(vector));
mn = min( min(vector) );


%% ��tickvalue
if ~exist('tickvalue', 'var') 
    diffs = unique(abs( diff(vector) ) );
    mndiff = min( diffs(diffs> 0.001*(mx-mn)) );
    
    % ��Ϊ��һ����ɢ�������Ľ��ޣ�100��mndiff
    if (mx-mn)/mndiff < 100
        tickvalue = mndiff;
    else
        tickvalue = (mx-mn)/20;
    end
end


%% main
h1 = subplot(1,2,1); hold off
plot( times, vector);
set(h1,'ylim',[mn, mx] );
title('value: time series')


%% main2
intervals = mn:tickvalue:mx;

h2 = subplot(1,2,2); hold off;
[N, X] = hist(vector, intervals);
barh(X, N );
set(h2,'ylim',[mn, mx] );
title('histogram along Y axis');

end

