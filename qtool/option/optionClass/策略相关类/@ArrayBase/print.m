function [txt] = print(obj)
% PRINT ��һ���У���ӡnode����Ҫ������node.println����
% [txt] = print(obj)
% --------------------------
% �̸գ�20160210

txt = '';
nd = obj.node;
L = length(nd);
for i =1:L
    txtln = nd(i).println;
    txt = sprintf('%s%s', txt, txtln);
end

if nargout == 0
    disp(txt);
end
end

