function [  ] = cleasing_emptyLast( obj )
%CLEASING_EMPTYLAST ������ϴ��lastΪ�ջ�0ʱ�����
% ������������Ͼ���ʱ�Σ�û��last
% --------------------------
% �̸գ�201609




%% �ֱ��汾
obj.last( obj.last == 0 ) = obj.preSettlement;

%% ���Ͼ���ʱ��Ҫ��last
% J = find(obj.last>0, 1, 'first');
% obj.last(1:J) = obj.preSettlement;


%% plot ��һ�£�debug��
plot_flag = 0;
if plot_flag == 1
    plot(obj.last);
end

end

