function displa = displacement( bars , window )
% ����һ�δ����ڵ�λ��
% ����:
% bars ���ݣ�
% window �����ڵĳ��ȣ�
% �����
% displa λ�Ƶ�ʱ�����С�

% by wuzehui, version v1.0, 2013/6/25
% by wuzehui, version v1.1, 2013/7/21

%
nperiod = length(bars.open);
displa = nan(nperiod,1);
displa(window:end) = bars.close( window:end ) - bars.open( 1:end-window+1 );

end % End of file