function [  ] = cleasing_emptyPQ( obj, tickvalue )
%CLEASING_EMPTYPQ ������ϴ�����۵�λ�п�ʱ������ȥֵ
% ������������Ͼ���ʱ��1�����ⶼû��
% ����������ҵ���Ȳ���ʱ��5��/10�����ڹҲ���
% ����������ǵ�ͣʱ
% ���������һ�������м۵��������ɵ����۸񼱾�䶯
% -----------------------------------
% �̸գ�201609


%% 
if ~exist('tickvalue', 'var')
    tickvalue = 0.01;
end

%% �򵥴ֱ��汾
% ������0
% ��iT-1��1��
% �õ͵���ߵ�


%% �Ȱѹҵ���������
obj.askQ(obj.askP==0) = 0;
obj.bidQ(obj.bidP==0) = 0;



%% 1���Ĵ�����ǰ�ҵ���
if obj.askP(1,1) == 0 , obj.askP(1,1) = obj.preSettlement;end
if obj.bidP(1,1) == 0, obj.bidP(1,1) = obj.preSettlement - 0.01; end

idx  = find(obj.askP(:,1)==0);
for id = 1:length(idx)   
    i = idx(id);
    if obj.bidP(i, 1) >0   % ����bidP����+1
        obj.askP(i,1) = obj.bidP(i,1) + tickvalue;
    else
        obj.askP(i, 1) = obj.askP(i-1,1);
    end
end

idx  = find(obj.bidP(:,1)==0);
for id = 1:length(idx)
    i = idx(id);
    if obj.askP(i, 1) >0  % ����askP����-1 
        obj.bidP(i,1) = obj.askP(i,1) - tickvalue;
    else
        obj.bidP(i, 1) = obj.bidP(i-1,1);
    end
end

    
%% 2-10���Ĵ���   

LEVEL = size(obj.askP, 2);

for iLV = 2:LEVEL
    idx = obj.askP(:,iLV)==0;
    obj.askP(idx,iLV) = obj.askP(idx,iLV - 1) + tickvalue;
    
    idx = obj.bidP(:,iLV)==0;
    obj.bidP(idx,iLV) = obj.bidP(idx,iLV - 1) - tickvalue;
end
         
         

%%  ��ͼ, debug��
plot_flag = 0 ;
if plot_flag == 0
    return;
end

figure(201); hold off
plot(obj.askP(:,1)); hold on
plot(obj.bidP(:,1),'r')

figure(202); hold off
plot(obj.askP(:,1) - obj.bidP(:,1))

figure(211); hold off
plot(obj.askP(:,2));hold on
plot(obj.bidP(:,2), 'r') ; 


figure(212); hold off
plot( obj.askP(:, LEVEL)); hold on;
plot( obj.bidP(:, LEVEL), 'r')
    
end

