function [ pnl, frq, text ] = market_maker_strategy_backtest_cg( entrustList, tradeList, FEE, outFlag)
%MARKET_MAKER_STRATEGY_BACKTEST_CG��һ�յ�entrustList��tradeList���Ϸ��������̲��Ե�Ч��
% ���룺 entrustList�µ�����ϵ�����tradeList�ɽ������ز�ʱ���Ʋ⣩
% �����frq��pnl�� ��5�����Σ�˫�ɣ�˫�ܣ��򵥳ɣ������ɣ�������
% text��һ����ʽ�ÿ����ı����
% ʹ�÷�Χ�ܾ��ޣ���Ʒ�֣������̲��ԣ�ÿ����һ�֣��޼۵�
% �̸գ�20140608

%% 
if ~exist('entrustList', 'var') || ~exist('tradeList', 'var')
    disp('ȱ���������');
    return;
end

if ~exist('outFlag', 'var'), outFlag = 1 ; end


%% �������ǻ���EntrustList��TradeList�ķ���


%% �ȷֳɹ�ʧ�ܺ�������5�����ͳ��freq��pnl

tlcombNo = nan(tradeList.latest, 1);
for i = 1:tradeList.latest
    tlcombNo(i) = entrustList.combNo( entrustList.entrustNo == tradeList.entrustNo(i) ) ;
end

arrRoundNo = unique(tlcombNo);

netPosition = 0;
roundPNL = 0;
for iComb = 1:length(arrRoundNo)
    idx  = find(tlcombNo == iComb);
    
    netPosition(iComb) = sum( - tradeList.specialMark(idx).*tradeList.direction(idx) ); 
    roundPNL(iComb)   = sum( - tradeList.price(idx) .* tradeList.direction(idx) .* tradeList.volume(idx) );
end

% ����
% ��һ�ࣺ˫��    
frq(1) = sum( netPosition == 0);
pnl(1) = sum( roundPNL( netPosition == 0 ) );

% �ڶ��ࣺ˫��, ��ʵ������
frq(2) = 0;
pnl(2) = 0;

% �����ࣺ��ɣ����ܣ����
frq(3) = sum( netPosition > 0 );
pnl(3) = sum( roundPNL( netPosition > 0 ) );

% �����ࣺ:���ɣ���ܣ����
frq(4) = sum( netPosition < 0 );
pnl(4) = sum( roundPNL( netPosition < 0 ) );

% ���5�� ������
frq(5) = frq(1) + frq(2)+ frq(3) + frq(4);
pnl(5) = - FEE * frq(5);




%% ���
avgpnl = pnl./frq;
avgpnl(2) = 0;
ratio = frq./sum(frq(1:4));

% figtext���
text = nan;
text = sprintf(    '             ˫��   ˫��   ���   ���   ������');
text = sprintf('%s\nfrq:        %6d %6d %6d %6d %6d',text, frq(1:5));
text = sprintf('%s\npnl:        %6.0f %6.0f %6.0f %6.0f %6.0f',text, pnl(1:5));
text = sprintf('%s\navgpnl:     %6.1f %6.0f %6.0f %6.0f %6.1f', text, avgpnl(1:5));
text = sprintf('%s\n%%  :        %6.1f %6.1f %6.1f %6.1f', text, ratio(1:4)*100);
text = sprintf('%s\nttlPNL:     %6.1f', text, sum(pnl));

if outFlag 
    text
end




end

