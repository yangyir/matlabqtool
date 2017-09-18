classdef MPause < handle
% 本程序主要是用于Matlab运行时中断程序
% Alt+F10 是中断程序进行调试，通常需要在需要查看数据的地方加入断点，
% 键入return后进行正常的调试
% Alt+F12 是暂停程序
% 使用demo（运行后，alt-F12配合enter，alt-F10配合F5用）：
%     myPause = MPause();
%     myPause.start();
%     for k =1:100
%         disp(num2str(k));
%         pause(1);
%     end
%     myPause.finish();

% 和群；140801


    methods(Access = 'public', Static = false, Hidden = false)
        function [obj] = start(obj)
            success = MEXPause('Start');
            if success
                disp('Debug Mode Starting...');
            else
                disp('Debug Mode is already started!');
            end
            global timerPause;
            timerPause = timer('TimerFcn',@situation, 'Period', 1,'ExecutionMode','fixedSpacing');
            start(timerPause);
        end
        
        function [obj] = finish(obj)
            success = MEXPause('Finish');
            if success
                disp('Debug Mode Finished!');
            else
                disp('Debug Mode is already Finished!');
            end
            global timerPause;
            stop(timerPause);
            delete(timerPause);
        end
        
        function [obj] = clear(obj)
            success = MEXPause('Finish');
            if success
                disp('Debug Mode Finished!');
            else
                disp('Debug Mode is already Finished!');
            end
            AT = timerfindall;
            delete(AT);
        end
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        
    end
end

function situation(obj, event)
flag = MEXPause('GetState');
if flag == 2
    keyboard;
elseif flag == 1
    input('Press enter to continue...\n', 's');
end
end
