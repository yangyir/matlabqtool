function [isequal] = double_equal(src, dst)
% double_equal Ŀ���Ǽ�������������Ƿ���ȣ����ڸ�����������о�����ʧ����==���� >= <= ���߼������
% δ���ܹ��õ�Ԥ�ڵĽ����������double_equal���ж���ȡ�
% true = abs(src - dst) < exp(-8)
% false = abs(src - dst) >= exp(-8)
    isequal = abs(src - dst) < exp(-8);
end