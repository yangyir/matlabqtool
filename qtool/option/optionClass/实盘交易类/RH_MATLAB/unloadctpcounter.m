function [] = unloadctpcounter()
% [] = unloadctpcounter()
% ж��CTP_Counter��̬��
%------------------------
% �콭 2016.6.20 first draft

if (libisloaded('CTP_Counter'))
    unloadlibrary('CTP_Counter')
end

end