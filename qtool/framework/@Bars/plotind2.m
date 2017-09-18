function [  ] = plotind2( obj, sig, ind, isSplit)
%PLOTIND2 shows indicated places on a close price chart
% [  ] = plotind2( obj, sig, ind, isSplit)
% inputs::
%   sig             vector of 0 1,�ź�
%   ind             struct of index, tai��tai2�����ֵ
%   isSplit         ==1 split,  ==0 not(default)
% outputs:
%   output1         û�����ֵ��ֻ��ͼ
% example:
%   [~,~,ind] = tai2.tsi(bars);
%   bars.plotind2( [ 0;0;1], ind, 1)
% -----------------------------------------------------
% ver 1.0;  zhanghang;     20130410;
% ver1.1; Cheng,Gang; 20130422; �޸���ע��



%% pre-process
%Ĭ��ֵ
if ~exist('isSplit','var'), isSplit = false; end



% ����ind
indcell = struct2cell(ind);

field = fieldnames(ind);
names = cell(length(field) + 3, 1);
names{1} = '���̼�';
names{2} = 'sig+';
names{3} = 'sig-';
for i = 1: length(field)
    names{i + 3} = field{i};
end



%% main
figure

% ���ָ��ֵ�� bars.close ��أ�����һ��ͼ��
% ���򣬷ֿ���
if isSplit
    subplot(2, 1, 1);
    hold all
    plot(   1:length(obj.close),    obj.close, ...
            find(sig == 1),         obj.close(sig == 1), '+r', ... 
            find(sig == -1),        obj.close(sig == -1), '*g');
        
    legend('���̼�', 'sig+', 'sig-');
    hold off
    subplot(2, 1, 2);
    hold all
    for i = 1: length(indcell)
        plot(indcell{i});
    end
    legend(field);
else
    hold all
    plot(   1:length(obj.close),    obj.close, ...     
            find(sig == 1),         obj.close(sig == 1), '+r', ... 
            find(sig == -1),        obj.close(sig == -1), '*g');
        
    for i = 1: length(indcell)
        plot(indcell{i});
    end
    legend(names);
end

hold off

end