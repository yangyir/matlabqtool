function [UpInd,DownInd,FluxInd] = ContinTrendIdentify(bars, tol1, uppercent, downpercent, tol2)
% by Yang Xi v1.0
% �������������������źŹ��������������ƵĻ���
% bars Ϊ���ƻ��ֵĶ���
% tol1, uppercent, downpercentΪ����ContinTrend����Ҫ
% uppercent��downpercent�ο�0.02
% tol1 �Ĳο�ֵΪһ�������յĵ�λʱ��������barsΪ�������ݣ�tol1�ο�241
% tol2 Ϊ�źŹ��˺���ContinFilter��Ч�ź�Ҫ�����̳��ȣ���barsΪ�������ݣ�tol2�ο�60
[upcount,downcount]=marketstatus.ContinTrend(bars, tol1, uppercent, downpercent);
UpInd = [];
for i = 1: length(upcount(:,1))
    UpInd = [UpInd upcount(i,2):upcount(i,3)];
end
DownInd = [];
for i = 1:length(downcount(:,1))
    DownInd = [DownInd downcount(i,2):downcount(i,3)];
end
FullInd = 1:length(bars.close);
FluxInd = setdiff(setdiff(FullInd, UpInd),DownInd); % ��������֮������Ϊ�������
Fluxsignal = zeros(1, length(bars.close));
Fluxsignal(FluxInd) = 1;
FluxFiltLoc = marketstatus.ContinFilter(Fluxsignal,tol2); % ���˵������ź��е���Ч�϶�ֵ
FluxInd = setdiff(FluxInd, FluxFiltLoc);
for i = 1:length(FluxFiltLoc)
    if ismember(FluxFiltLoc(i)-1,UpInd)
        UpInd = sort([UpInd FluxFiltLoc(i)]);
    end
    if ismember(FluxFiltLoc(i)-1,DownInd)
        DownInd = sort([DownInd FluxFiltLoc(i)]);
    end
end

end