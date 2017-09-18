function [nav1,nav2] = process(nav1, Date1, nav2, Date2)
% 把不同周期的nav1，nav2对齐
% -------------------------
% 唐一鑫，20150730

start1 = Date1(1);
start2 = Date2(1);
end1 = Date1(end);
end2 = Date2(end);


if start1 <= start2
    if end1 < start2
        nav1 = nav1 ./ nav1(1);
        nav2 = nav2 ./ nav2(1) .* nav1(end);
    else
        j = length(nav1);
        while(true)
            if(Date1(j)<start2)
                break;
            else
                if j == 1
                break;
                end
                j = j-1;
            end
        end
        nav1 = nav1./nav1(1);
        temp = interp1([Date1(j),Date1(j+1)],[nav1(j),nav1(j+1)],start2);
        nav2 = nav2./nav2(1).*temp;
    end
else
    if end2 < start1
        nav2 = nav2 ./ nav2(1);
        nav1 = nav1 ./ nav1(1) .* nav2(end);
    else
        j = length(nav2);
        while(true)
            if(Date2(j)<start1)
                break;
            else
                 if j == 1
                break;
                end
                j = j-1;
            end
        end
        nav2 = nav2./nav2(1);
        temp = interp1([Date2(j),Date2(j+1)],[nav2(j),nav2(j+1)],start1);
        nav1 = nav1./nav1(1).*temp;
    end
    


end
