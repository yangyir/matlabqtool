function [ ztMat, dtMat ]      = dhZhangDieTingMat( tsMat, type)
%��DH������ɵ��ǵ�ͣ״��
%[ ztMat, dtMat ]  = dhZhangDieTingMat( tsMat, type)
% type�� 
%     1 - һ����ͣ�����޻�����
%     2 - ������ͣ����ĩ���޻�����
%     3 - ������ͣ
%     4 - ������ͣ����ĩ��
% --------------------
% �̸գ�20150525�����汾


%% Ԥ����
% �ж�����
if ~isa(tsMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeQmat');
end

if ~exist('type', 'var')
    type = 1;
end

%% ��¼
ztMat = tsMat.getCopy;
ztMat.des = '��ͣ';
ztMat.datatype = '0/1';
ztMat.data   = zeros( size(ztMat.data) );

dtMat = ztMat.getCopy;
dtMat.des = '��ͣ';

%% 
hiMat   = th.dhPriceMat( tsMat, 'High', 2);
preCMat = th.dhPriceMat( tsMat, 'PreClose', 2);
loMat   = th.dhPriceMat( tsMat, 'Low', 2);
hi      = hiMat.data;
preC    = preCMat.data;
lo      = loMat.data;

switch type
    case{1, '1'}
        % �ж�һ����ͣ�� �� = �� �� ǰ��
        ztMat.data = ( hi==lo)  & ( hi>preC) ;
        ztMat.des2 = 'һ��';
        
        % �ж�һ�ֵ�ͣ�� �� = �� < ǰ��
        dtMat.data = ( hi==lo)  & ( hi<preC) ;
        dtMat.des2 = 'һ��';
        
        
    case{2,'2'}
        clMat   = th.dhPriceMat( tsMat, 'Close', 2);
        cl      = clMat.data;
        
        % �ж���ĩ��ͣ�� �� = �� = ǰ��*1.1
        ztMat.data = (hi==cl)  & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '��ĩ';
        
        % �ж���ĩ��ͣ�� �� = �� = ǰ��*0.9
        dtMat.data = (cl==lo)  & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '��ĩ';
        
    case{3,'3'}
        opMat   = th.dhPriceMat( tsMat, 'Open', 2);
        op      = opMat.data;
        
        % �жϿ�����ͣ�� �� = �� = ǰ��*1.1
        ztMat.data = (op==hi)  & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '����';
        
        % �жϿ��̵�ͣ�� �� = �� = ǰ��*0.9
        dtMat.data = (op==lo)  & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '����';
        
    case{4, '4'}
        clMat   = th.dhPriceMat( tsMat, 'Close', 2);
        cl      = clMat.data;
        
        % �ж�������ͣ�� �� < �� = ǰ��*1.1
        ztMat.data =  (cl<hi) & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '����';
        
        
        % �ж����е�ͣ�� �� �� �� = ǰ��*0.9
        dtMat.data = (cl>lo) & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '����';


        
        
end




end

