%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������������һ��radio��״̬����radiohandle(1)��Ӧ��radio��value����Ϊ��Max��
% ����radio��value����Ϊ��Min����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_radio_state(radiohandle)

set(radiohandle(1),'value',get(radiohandle(1),'Max'));
for Index =2:length(radiohandle)
   set(radiohandle(Index),'value',get(radiohandle(Index),'Min'));
end

end