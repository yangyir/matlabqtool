function dist_disp_ratio = dist_disp_ratio( bars , window )
% distance displacement ratio
% by Wu Zehui ,version 1.0 ,2013/6/25

%º∆À„
dist_disp_ratio = marketstatus.distance( bars, window)./ ...
    marketstatus.displacement( bars, window );

end% end of file