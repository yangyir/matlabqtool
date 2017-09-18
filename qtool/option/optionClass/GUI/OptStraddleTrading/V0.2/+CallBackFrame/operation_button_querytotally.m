function operation_button_querytotally(hObject, eventdata, handles)
% “ªº¸≤È—Ø
% Œ‚‘∆∑Â 20170329

global MULTI_INSTANCE;
global STRA_INSTANCE;

if isempty(STRA_INSTANCE)
    MULTI_INSTANCE.query_all_pendingEntrusts;
else
    STRA_INSTANCE.query_book_pendingEntrusts;
end




end