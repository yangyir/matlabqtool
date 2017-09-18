function [upcount,downcount] = ContinTrend(bars, tol, uppercent, downpercent)
% v0.0 by Zehui Wu
% v1.0 by Yang Xi
% ͨ���������������ֳ��г�������״̬
% tol��ʾ�������̵ķ����Ƹ���
% uppercent��ʾ������Ҫ������������
% downpercent��ʾ������Ҫ�������µ���
% ����ֵ upcount downcount�ĵ�һ�м�¼ʵ�����ǻ��µ�������ȥ���س����ڶ��м�¼���Ƶ���� �����м�¼�����յ�

open = bars.open;
close = bars.close;
ntotal = length(open);
% ����ÿ����ǵ�������1��ʾ������-1��ʾ��
updown = ones(ntotal,1);
updown(open>close) = -1;
i = 1;

% ��һ�м�¼ʵ������/�µ�������ȥ���س����ڶ��м�¼���Ƶ���� �����м�¼�����յ�
upcount = zeros(ntotal, 3);
downcount = zeros(ntotal, 3);
iupcount = 1;
idowncount = 1;
while i <= ntotal
    tmpupnum = 0;%��¼ÿ�����Ƶ����ǵĸ���
    tmpdownnum = 0;%��¼ÿ�����Ƶ������ĸ���
    lastupnum = 0;
    lastdownnum = 0;
    if updown(i) == 1 % �������ǿ�ʼ
        lastindex = i;
        j = i;
        while j<= ntotal
            nday = max(tol, round(tmpupnum+tmpdownnum)*0.4); % ��nday����Ӧ�仯
            if updown(j) == 1
                tmpupnum = tmpupnum+1;
            else
                tmpdownnum = tmpdownnum+1;
            end
            if updown(j) == 1 && tmpupnum > tmpdownnum && tmpdownnum <= nday && (close(j)-open(i))/open(i) > uppercent
                lastindex = j;
                lastupnum = tmpupnum;
            end
            if tmpdownnum > nday || j == ntotal
                if lastindex > i
                    upcount(iupcount, :) = [lastupnum i lastindex];
                    i = lastindex+1;
                    iupcount = iupcount+1;
                else 
                    i = i+1;
                end
                break;
            end
            j = j+1;
        end
    else
        nday = max(tol, round(tmpupnum+tmpdownnum)*0.4);
        lastindex = i;
        j = i;
        while j<= ntotal
            if updown(j) == 1
                tmpupnum = tmpupnum+1;
            else
                tmpdownnum = tmpdownnum+1;
            end
            if updown(j) == -1 && tmpupnum < tmpdownnum && tmpupnum <= nday && (open(i)-close(j))/open(i) > downpercent
                lastindex = j;
                lastdownnum = tmpdownnum;
            end
            if tmpupnum > nday || j == ntotal
                if lastindex > i
                    downcount(idowncount, :) = [lastdownnum i lastindex];
                    idowncount = idowncount+1;
                    i = lastindex+1;
                else
                    i = i+1;
                end
                break;
            end
            j = j+1;
        end
    end 
end
upcount = upcount(1:iupcount-1, :);
downcount = downcount(1:idowncount-1, :);
end
