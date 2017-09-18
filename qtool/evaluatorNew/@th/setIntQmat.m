function  [qmat] = setIntQmat( qmat, round_type)
% �������������������Ҫ��������
% û������Ƿ�Ҫpositive
% [qmat] = setIntQmat( qmat, round_type)
% round_type: 1-�������루Ĭ�ϣ���2-���£�3-����
% ----------------
% �̸գ�20150524�����汾


%% Ԥ����
if ~isa(qmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�qmat');
end

if ~exist('round_type', 'var')
    round_type = 1;
end


%% main
qmat.des2     = '����';
qmat.datatype = '����double';

switch round_type 
    case {1,'round' }
        qmat.data = round(qmat.data);
    case {2, 'floor' }
        qmat.data = floor(qmat.data);
    case {3, 'ceil'}
        qmat.data = ceil(qmat.data);
end

% �������0��

end

