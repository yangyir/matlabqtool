%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于设置一组radio的状态，将radiohandle(1)对应的radio的value设置为‘Max’
% 其余radio的value设置为‘Min’。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_radio_state(radiohandle)

set(radiohandle(1),'value',get(radiohandle(1),'Max'));
for Index =2:length(radiohandle)
   set(radiohandle(Index),'value',get(radiohandle(Index),'Min'));
end

end