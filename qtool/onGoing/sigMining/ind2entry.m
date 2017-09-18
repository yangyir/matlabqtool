function [ sigEntry  ] = ind2entry(sig)
% convert positive value to long and negative value to short. 
% each column of indicators is tagged differently.


[~, nCol] = size(sig.indVal);
len = sum(sum(sig.indVal~=0));
sigEntry = nan(len,5);
iRow = 1;
iNum = 1;
for i = 1:nCol
    % long
    idx  =[nan; sig.indVal(1:end-1,i)]>0;
    % !! entry must be at least ONE LAG of indVal
    nEntry = sum(idx);
    if nEntry
        
        sigEntry(iRow:iRow+nEntry-1,:) = [(iNum:iNum+nEntry-1)', sig.time(idx), sig.ask(idx),...
                                 repmat(100,nEntry,1), i*ones(nEntry,1)];
        iRow = iRow +nEntry;  
    end
    iNum = iNum+nEntry;
    % short
    idx  =[nan; sig.indVal(1:end-1,i)]<0;
    nEntry = sum(idx);
    if nEntry
        
        sigEntry(iRow:iRow+nEntry-1,:) = [(iNum:iNum+nEntry-1)', sig.time(idx), sig.bid(idx),...
                                 repmat(-100,nEntry,1), i*ones(nEntry,1)];
        iRow = iRow +nEntry;  
    end
    iNum = iNum+nEntry;
    
end
    
