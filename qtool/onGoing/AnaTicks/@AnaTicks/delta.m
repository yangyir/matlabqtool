
function deltavalue = delta(Ticks1,Ticks2,AdjustMethod)
% delta   ���������ʲ���ɢ��ͼ���������
% inputs;
%   Ticks1: �ʲ�1��Ticks����
%   Ticks2���ʲ�2��Ticks����
%   AdjustMethod�� ���ݵ�����ʽ
%   -- 1    ���Բ�ֵ,��ֵ���
%   -- 11	���Բ�ֵ��ȡunique
%   -- 2    ��һ������ֵ��Ϊ��ǰֵ
%   -- 21	��һ������ֵ��Ϊ��ǰֵ��ȡunique
%   -- 3    ��Stock������Call������һ�������ڵĽ���
%   -- 31   ��Stock������Call������һ�������ڵĽ���,ȡunique
% 2014.06.03; hu,yi
% 2014.6.3, luhuaibao, �������飬������ͼ


%% ��������
A1MinP = 0.01;  %�ʲ�1����ͼ�
A2MinP = 0.01;  %�ʲ�2����ͼ�
if ~exist('AdjustMethod','var')
    AdjustMethod = 31;
end
%% ��������
nA1Time = Ticks1.latest;  
A1Time = Ticks1.time(1:nA1Time);    
A1Price = Ticks1.last(1:nA1Time);
A1Vol = Ticks1.volume(1:nA1Time);
A1Name = Ticks1.code;

nA2Time = Ticks2.latest;
A2Time = Ticks2.time(1:nA2Time);
A2Price = Ticks2.last(1:nA2Time);
A2Vol = Ticks2.volume(1:nA2Time);
A2Name = Ticks2.code;


if isempty(A1Name)
    A1Name = '����1';
end ;

if isempty(A2Name)
    A2Name = '����2';
end ;


%% ����Ԥ����ȥ��û��ʵ�ʳɽ���tick����
idx = find(diff(A1Vol))+1;
A1Time = A1Time(idx);
A1Price = A1Price(idx);
idx = find(diff(A2Vol))+1;
A2Time = A2Time(idx);
A2Price = A2Price(idx);

%% ȡ9:30 - 11:30,13:00-15:00֮�������
t = datestr(A1Time(1));
t1 = datenum([t(1:12),'09:30:00']);
t2 = datenum([t(1:12),'11:30:00']);
t3 = datenum([t(1:12),'13:00:00']);
t4 = datenum([t(1:12),'15:00:00']);
idxS = (A1Time>=t1&A1Time<=t2) + (A1Time>=t3&A1Time<=t4);
idxC = (A2Time>=t1&A2Time<=t2) + (A2Time>=t3&A2Time<=t4);
A1Time = A1Time(idxS>0);
A1Price = A1Price(idxS>0);
A2Time = A2Time(idxC>0);
A2Price = A2Price(idxC>0);
Time = sort(union(A1Time,A2Time));
nTime = length(Time);
AdA1Price = zeros(nTime,1);
AdA2Price = zeros(nTime,1);
[~,idxS] = ismember(A1Time,Time);
AdA1Price(idxS) = A1Price;
[~,idxC] = ismember(A2Time,Time);
AdA2Price(idxC) = A2Price;

%% ���ݲ�ֵѡȡ
%-- ���Բ�ֵ
if AdjustMethod == 1
    % ��Ʊ�۸�����
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    iEnd = find(AdA1Price>A2MinP,1,'last');
    AdA1Price(iEnd+1:end) = AdA1Price(iEnd);
    idx = find(AdA1Price);
    AdA1Price = interp1(idx,AdA1Price(idx),1:nTime);
    % Call Option����
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    iEnd = find(AdA2Price>A1MinP,1,'last');
    AdA2Price(iEnd+1:end) = AdA2Price(iEnd);
    idx = find(AdA2Price);
    AdA2Price = interp1(idx,AdA2Price(idx),1:nTime);
end

if AdjustMethod == 11
    % ��Ʊ�۸�����
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    iEnd = find(AdA1Price>A2MinP,1,'last');
    AdA1Price(iEnd+1:end) = AdA1Price(iEnd);
    idx = find(AdA1Price);
    AdA1Price = interp1(idx,AdA1Price(idx),1:nTime);
    % Option����
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    iEnd = find(AdA2Price>A1MinP,1,'last');
    AdA2Price(iEnd+1:end) = AdA2Price(iEnd);
    idx = find(AdA2Price);
    AdA2Price = interp1(idx,AdA2Price(idx),1:nTime);
    % ȡuniqueȥ���ظ���
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end
%-- ��һ������ֵ��Ϊ��ǰֵ
if AdjustMethod == 2
    % ��Ʊ�۸�����
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    for t = 1:nTime
        if AdA1Price(t) <= A2MinP
            AdA1Price(t) = AdA1Price(t-1);
        end
    end
    % Option����
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    for t = 1:nTime
        if AdA2Price(t) <= A1MinP
            AdA2Price(t) = AdA2Price(t-1);
        end
    end
end

if AdjustMethod == 21
    % ��Ʊ�۸�����
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    for t = 1:nTime
        if AdA1Price(t) <= A2MinP
            AdA1Price(t) = AdA1Price(t-1);
        end
    end
    % Option����
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    for t = 1:nTime
        if AdA2Price(t) <= A1MinP
            AdA2Price(t) = AdA2Price(t-1);
        end
    end
    % ȡuniqueȥ���ظ���
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end
%-- ��Call������Stock���е���һ������ֵ�ڵĽ���
if AdjustMethod == 3
    win = 5;
    nPoint = 0;
    for t = win+1:nTime-win
        if any(AdA1Price(t-5:t+5)>A2MinP) && any(AdA2Price(t-5:t+5)>A1MinP)
            nPoint = nPoint + 1;
            newTime(nPoint) = Time(t);
            idx = find(AdA1Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP1(nPoint) = AdA1Price(t-6+idx(imin));
            idx = find(AdA2Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP2(nPoint) = AdA2Price(t-6+idx(imin));
        end
    end
    Time = newTime;
    AdA1Price = newP1;
    AdA2Price = newP2;
end

if AdjustMethod == 31
    win = 10;
    nPoint = 0;
    for t = win+1:nTime-win
        if any(AdA1Price(t-5:t+5)>A2MinP) && any(AdA2Price(t-5:t+5)>A1MinP)
            nPoint = nPoint + 1;
            newTime(nPoint) = Time(t);
            idx = find(AdA1Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP1(nPoint) = AdA1Price(t-6+idx(imin));
            idx = find(AdA2Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP2(nPoint) = AdA2Price(t-6+idx(imin));
        end
    end
    Time = newTime;
    AdA1Price = newP1;
    AdA2Price = newP2;
    % ȡuniqueȥ���ظ���
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end

%% ������ͼ
nPoint = length(AdA1Price);
figure;
%-- һ�����
% subplot(1,2,1);
scatter(AdA1Price,AdA2Price);
hold on
P1 = polyfit(AdA1Price,AdA2Price,1);
xl = xlim;
x = linspace(xl(1),xl(2));
y = polyval(P1,x);
plot(x,y,'r');
hold off
yl = get(gca,'ylim');
axis([xl(1) xl(2) yl]);
yfit = polyval(P1,AdA1Price);
R2 = norm(yfit-mean(AdA2Price))^2/norm(AdA2Price-mean(AdA2Price))^2;
% title([num2str(P1),'; R^2 = ',num2str(R2),';��',num2str(nPoint),'����']);
title(['\Delta = ',num2str(P1(1)),'; R^2 = ',num2str(R2),'; ��',num2str(nPoint),'����']);
xlabel(A1Name);
ylabel(A2Name);

deltavalue = P1(1) ; 

%-- �������
% subplot(1,2,2);
% scatter(AdA1Price,AdA2Price);
% hold on
% P2 = polyfit(AdA1Price,AdA2Price,2);
% x = xlim;
% x = x(1):0.01:x(2);
% y = polyval(P2,x);
% plot(x,y,'r');
% hold off
% yfit = polyval(P2,AdA1Price);
% R2 = norm(yfit-mean(AdA2Price))^2/norm(AdA2Price-mean(AdA2Price))^2;
% title([num2str(P2),'; R^2 = ',num2str(R2),';��',num2str(nPoint),'����']);
% set(gcf,'unit','centimeters','position',[6 10 25 10]);

end