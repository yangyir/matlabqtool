%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于Main中右图1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right1_m(f,main)

h = axes('parent',f,'position',[0.84,0.63,0.15,0.21]);

wintim = main.wintradetime;
losetim = main.losetradetime;
label_w = ['win',blanks(2),num2str(wintim)];
label_l = ['lose',blanks(2),num2str(losetim)];

if wintim == 0  && losetim ~= 0 
    pie(losetim,{label_l});
    colormat=[0,1,0];
    colormap (colormat);
elseif wintim ~= 0  && losetim == 0
    pie(wintim,{label_w});
    colormat=[1,0,0];
    colormap (colormat);
elseif wintim ~= 0  && losetim ~= 0
    pie([wintim,losetim], {label_w,label_l});
    colormat=[1,0,0;0,1,0];
    colormap (colormat);
else
    disp('No win! No lose!')
end
    

title('盈利与损失交易次数比');

end