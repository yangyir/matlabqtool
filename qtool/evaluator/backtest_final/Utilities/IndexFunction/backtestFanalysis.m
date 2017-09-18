%%%%%%%%%%%%%%%%%%%%%%%%%% backtestF analysis %%%%%%%%%%%%%%%%%%%%%%%

% �� backtestF.m �Ľ������׼ȷ��ÿ�ʽ���gap��ÿ������rev��
% �����ʧmaxDrawdown�Ƚ���ķ�����
% ����ӿ�ֱ�Ӷ�Ӧ backtestF.m ����� result�� �����bars��
% configure


function[result_anal] = backtestFanalysis(result ,bars ,configure)

    account = result.Detail.account;
    tradeList = result.Detail.tradeList;

    %% calculating

    % gap

    [nrow,~] = size(tradeList);
    result_anal.gap = zeros(nrow,1);

    for i = 1:nrow
        gap_temp = account(bars.time == tradeList(i,4)) -...
            account(bars.time == tradeList(i,3));
        result_anal.gap(i) = gap_temp / (configure.multiplier *...
            bars.open(find(bars.time == tradeList(i,3))+1) *...
            (1 + configure.cost));
    end

    % rev

    timeSlice = mode(diff(bars.time));
    slicesPerDay = fix(1/24*4.5/timeSlice);
    [nrow,~] = size(account);
    result_anal.rev = zeros(nrow/slicesPerDay,1);

    for i = 1:length(result_anal.rev)
        rev_temp = account(slicesPerDay*i) - account(slicesPerDay*(i-1)+1);
        result_anal.rev(i) = rev_temp / (configure.multiplier *...
            mean(bars.close((slicesPerDay*(i-1)+1):(slicesPerDay*i))));
    end

    % maxDrawdown

    % ��� backtestF_analysis �� maxDrawDown �����޸ĵİ汾
    % ����IF00�Ĳ���Ŀǰ���Զ���ÿ��ֻ��1�֣�ԭ�����㷽������
    % ��Ϊʹ DrawDown �𽥱�С�����������޸ģ�
    % �����س����¶���Ϊ���ܻس�ֵ/ÿ�λس���ʼ�㿪һ��IF��Լ
    % �ļ۸�

    lowLevel = account;
    for i = 1:(length(account)-1)
        if account(end-i)<lowLevel(end-i+1)
            lowLevel(end-i)=account(end-i);
        else
            lowLevel(end-i) = lowLevel(end-i+1);
        end
    end
    drawDown = (account-lowLevel)./(configure.multiplier * bars.open);

    result_anal.maxDrawdown = max(drawDown);
    time_tmp = find(drawDown==result_anal.maxDrawdown,1,'first');
    result_anal.maxDrawdownBegT = datestr(bars.time(time_tmp));
    result_anal.maxDrawdownEndT = datestr(bars.time(find(lowLevel==...
        lowLevel(time_tmp),1,'last')));
    
    % final NAV
    
    result_anal.finalNAV = prod(result_anal.gap+1);
    
end

