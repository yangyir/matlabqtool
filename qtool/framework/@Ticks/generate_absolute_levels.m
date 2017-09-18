function [ paxis, defense, mark ] = generate_absolute_levels( b )
%GENERATE_ABSOLUTE_LEVELS �˴���ʾ�йش˺�����ժҪ
% �����
% paxis �� ���Լ۸�����
% defense�� �ҵ������ھ���������*ʱ��
% mark :    �ҵ��������ʣ�0-Ԥ����1-ask��2-bid
% ------------------
% �̸�, 201608




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
mx = round( max(b.askP(:,10)) *100 );
mn = round( min(b.bidP(II:end, 10)) *100 );
paxis = mn:mx;
NP = length(paxis);

% ����������������
defense = nan(Tb, NP);
mark = zeros(Tb, NP);   % 0 - ��ȷ�������ɼ������һ�ι۲�ֵ


% ��b��������������
tic
% ��ʱ��tick����
for iT = II:Tb
    thisline = nan(1, NP);    
    
    % ja��jb��10���ľ�������ֵ
    ja = round( b.askP(iT, :) * 100 - mn + 1 );
    jb = round( b.bidP(iT, :) * 100 - mn + 1 );
   
    
    % ���ڹҵ�ϡ�裬�пյ���j�Ŀ�ȿ��ܴ���10��
    % j����ڵĿյ�����ʵ��
    defense(iT, jb(end):ja(end) ) = 0;
    defense(iT, ja ) = b.askQ(iT, :);
    defense(iT, jb ) = b.bidQ(iT, :);

    mark(iT, ja(1):ja(end)) = 1;
    mark(iT, jb(end):jb(1)) = 2;
    

    % ��һ��ҲҪд��ȥ����Ϊ����ʷӰ�ӡ�
    if iT< Tb
        defense(iT + 1, : ) = defense(iT, :);
    end
    
end
toc



end


