%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ�ۼ�������������������ת��radio��callback
%  ע�⣺��hold������ 52 �� 56���� ע�͵������Խ�������е�Current plot held
%  Current plot released��ʾ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function radio_Equity_callback(r1,r2,r3,r4,r5,equity,h,fre)

cla(h);
% ��ʱ��ֱ���ǰ�����һ�죬��ֹ��Щ����ͼ�޷���ȫ��ʾ
max_t = max(equity.accum_returns(:,1))+1;
min_t = min(equity.accum_returns(:,1))-1;

switch fre
    case {'d'}
        handle = [r1,r2,r3,r4,r5];
        drawbar(equity.interval_returns_d,1);
        datetick(h,'x',29,'keeplimits');
        legend (h,'off');
    case {'w'}
        handle = [r2,r1,r3,r4,r5];
        drawbar(equity.interval_returns_w,2);
        datetick(h,'x',29,'keepticks','keeplimits');
        legend (h,'off');
    case {'m'}
        handle = [r3,r1,r2,r4,r5];
        drawbar(equity.interval_returns_m,3);
        datetick(h,'x',29,'keepticks','keeplimits');
        legend (h,'off');
    case {'y'}
        handle = [r4,r1,r2,r3,r5];
        drawbar(equity.interval_returns_y,4);
        datetick(h,'x',29,'keepticks','keeplimits');
        legend (h,'off');
    case {'a'}
        handle = [r5,r1,r2,r3,r4];
        plot(h,equity.accum_returns(:,1),equity.accum_returns(:,2),'r',equity.IR_acc(:,1),equity.IR_acc(:,2),'g');
        datetick(h,'x',29,'keeplimits');
        legend(h,{'�ۼ�������','ͬ�ڴ����ۼ�������'});
    otherwise
        error('Wrong input argument!')
end
set(h,'xlim',[min_t,max_t]);
% ����radio״̬
set_radio_state(handle);

% �������������������ʻ�barͼ
    function  drawbar(a,width)
        % ������Ϊ��
        a1 = a(a(:,2)>0,:);
        % ������Ϊ��
        a2 = a(a(:,2)<0,:);
        
        hold (h);
        if ~isempty(a1)
            % ���ÿ��
            a1 =[[a1(1,1)-width,0];a1];
            if size(a1,1)>= 2
                bar(h,a1(:,1),a1(:,2),1/(a1(2,1)-a1(1,1)),'r');
            else
                bar(h,a1(:,1),a1(:,2),0.8,'r');
            end
        end
        if ~isempty(a2)
            % ���ÿ��
            a2 =[[a2(1,1)-width,0];a2];
            if size(a2,1)>= 2
                bar(h,a2(:,1),a2(:,2),1/(a2(2,1)-a2(1,1)),'g');
            else
                bar(h,a2(:,1),a2(:,2),0.8,'g');
            end
        end
        hold(h);
    end

    end