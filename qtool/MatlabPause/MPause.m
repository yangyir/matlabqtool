classdef MPause < handle
% ��������Ҫ������Matlab����ʱ�жϳ���
% Alt+F10 ���жϳ�����е��ԣ�ͨ����Ҫ����Ҫ�鿴���ݵĵط�����ϵ㣬
% ����return����������ĵ���
% Alt+F12 ����ͣ����
% ʹ��demo�����к�alt-F12���enter��alt-F10���F5�ã���
%     myPause = MPause();
%     myPause.start();
%     for k =1:100
%         disp(num2str(k));
%         pause(1);
%     end
%     myPause.finish();

% ��Ⱥ��140801


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
