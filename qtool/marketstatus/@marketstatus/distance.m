function dist = distance( bars, window)
% ����һ�δ������ڵľ���
% ���룺
% bars���������ݣ�
% window�������ڵ�bar����
% �����
% dist�������ʱ������.
% version:v1.0 Wu Zehui 2013/6/25
% version:v1.1 Wu Zehui 2013/7/21

% Ԥ����
nperiod = length(bars.open);
if nperiod < window
    error('window input error.');
else
    dist = nan(nperiod,1);
    % ����
    absdist = abs(bars.close-bars.open);
    for iperiod = window:nperiod
        dist(iperiod) = sum(absdist(iperiod-window+1:iperiod));
    end
end
end % End of file