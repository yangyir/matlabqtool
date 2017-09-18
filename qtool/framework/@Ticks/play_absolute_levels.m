function [  ] = play_absolute_levels( b, s_itk, e_itk  )
%PLAY_ABSOLUTE_LEVELS ���ž��Լ۸񵵴������µĹҵ��仯
% ���룺
% s_itk: ��ʼtick���
% e_itk: ����tick���
% �����
% ------------------
% �̸�


%% ��������
Tb = length(b.last);
 
% plot(b.close)
% 
% figure(101); hold off
% plot(b.askP1);
% hold on;
% plot(b.bidP1);

midP = (b.askP(:,1) + b.bidP(:,1)) /2;
II1 = find(midP>0.01, 1, 'first') + 1;
II2 = find(b.askP(:,10)>0, 1, 'first') + 1;
II3 = find(b.bidP(:,10)>0, 1, 'first') + 1;
II = max( [ II1, II2, II3 ] );

% RG = [ min(midP(II:end)), max(midP) ];
% RGpct = 2 * (RG(2) - RG(1)) / sum(RG);
% RGtk = round ( (RG(2) - RG(1)) / 0.01 );

%% �����������꣬�����صı仯
 [ paxis, defense, mark ] = b.generate_absolute_levels;

 %% ��ͼ����ĳ����ʱ�����У����������仯
% for iP = 1:NP
% %     iP = 10;
% 
%     qs = defense(:, iP);
%     marks = mark(:, iP);
%     notVisible = marks == 0;
%     
%     idx = find(marks == 0 );
%     
%     figure(320); hold off
%     plot( idx, qs(idx), '*g');hold on
%     plot(qs,'.-'); hold on
%     title(sprintf('price level = %d', paxis(iP)));
%     pause(2)
% end




%% ��ͼ����ʱ��˳�����йҵ�
% TODO: ����������
if ~exist('s_itk', 'var')
    s_itk = II;
end

if ~exist('e_itk', 'var'),
    e_itk = Tb;
end



for iT = s_itk:e_itk
aline = defense(iT, :);
amark = mark(iT, :);
idx = find( amark==0 );
idx_ask = find( amark == 1);
idx_bid = find( amark == 2);

figure(333); hold off
barh( idx_ask, aline(idx_ask), 'b'); hold on
barh( idx_bid, aline(idx_bid), 'r')
barh( idx, aline(idx) ,'g') 
title(sprintf('iTick = %d, time = %d ', iT, b.time2(iT)));
pause(1)
end




end

