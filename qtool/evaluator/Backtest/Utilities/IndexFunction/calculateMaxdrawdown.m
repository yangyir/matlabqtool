function [MDD,MDDe,MDDs,MDDr]=calculateMaxdrawdown(r)

n = max(size(r));

% calculate vector of cum returns
cr = cumsum(r);

% calculate drawdown vector
for i = 1:n
    dd(i,:) = max(cr(1:i,:))-cr(i,:);
end;
MDD= max(dd);
% calculate maximum drawdown statistics
MDDe = find(dd==MDD);
MDDs = find(abs(cr(MDDe)+ MDD - cr) < 0.000001);
MDDr = MDDe+min(find(cr(MDDe:end) >= cr(MDDs)))-1;

end