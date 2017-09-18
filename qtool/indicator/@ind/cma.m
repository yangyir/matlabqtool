function [ cmaVal ] = cma( seq, semi_win  )
%CMA: Central Moving Average, simple
% seq             input sequence
% semi_win        semi window size of CMA
% simple special processing at head and tail. i.e.
% a(1:100), semiwindow = 10
% head = a(1:10) -> b(i) = mean( a(1: 2i+1) )
% body = a(11:90) -> normal 
% tail = a(91:100) -> similar to head
% ver 1.0, @author Cheng,Gang, 20130408 

% simple 
% body = semi_window_size: end - semi_window_size
% head = 1 : semi_window_size
% tail = end - semi_window_size : end

if ~exist('semi_win','var')
    semi_win=10;
end


% body: MA -> shift
% tsmovavg is an efficient choice
tsma = tsmovavg(seq,'s',semi_win*2+1,1);
bodyma = tsma(semi_win*2+1:end);


% head, tail: special processing 
headma = nan(semi_win,1);
tailma = nan(semi_win,1);

for i = 1:semi_win
    headma(i) = mean( seq(1:2*i-1) );
    tailma(end+1-i) = mean( seq(end+2-2*i : end) );
end

cmaVal = [headma;bodyma;tailma];

end

