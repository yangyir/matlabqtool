function  [qmat] = setIntQmat( qmat, round_type)
% 数量矩阵必须是整数，要进行舍入
% 没有理会是否要positive
% [qmat] = setIntQmat( qmat, round_type)
% round_type: 1-四舍五入（默认），2-向下，3-向上
% ----------------
% 程刚，20150524，初版本


%% 预处理
if ~isa(qmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的qmat');
end

if ~exist('round_type', 'var')
    round_type = 1;
end


%% main
qmat.des2     = '数量';
qmat.datatype = '整数double';

switch round_type 
    case {1,'round' }
        qmat.data = round(qmat.data);
    case {2, 'floor' }
        qmat.data = floor(qmat.data);
    case {3, 'ceil'}
        qmat.data = ceil(qmat.data);
end

% 必须大于0？

end

