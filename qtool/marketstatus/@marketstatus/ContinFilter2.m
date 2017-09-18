function newsignal = ContinFilter2(signal,tol)
newsignal = signal;
% if sum(signal(1:tol))>tol/2,
%     status = 1;
%     newsignal(1:tol) = 1;
% else
%     status = 0;
%     newsignal(1:tol) = 0;
% end

numOpp = 0;
status = signal(240);
for i = 241:length(signal)
    if signal(i) ~= status,
        numOpp = numOpp+1;
        newsignal(i) = status;
    end
    if numOpp == tol, % 反向发生
        newsignal(i) = 1-status;
        numOpp = 0;
        status = 1-status;
    end
    
end
end
    