function val = spliceQuoteByNodes( time , node , feature )
% time����ĵ�ǰʱ����Ƭ
% node��QuoteOpt��ɵ�ʱ����Ƭ�ϵ�����
% feature����Ӧ������
% ���������Ӧ��������Ƭ
% ���Ʒ� 20160717


if isempty( node )
    val = [];
    return;
end

setToday     = floor( node(1).quoteTime(1) );
morningStart = setToday + 9/24 + 30/24/60;
t_sz         = length( time );
val          = nan( t_sz , 1 );
start_time   = node(1).quoteTime;
end_time     = node(end).quoteTime;
node_sz      = length( node );

if start_time < morningStart
    
    val( 1 ) = node(1).(feature);
    t_end    = find( end_time > time );
    if isempty( t_end )
        val( 1 ) = node(end).(feature);
    else
        t_end    = t_end( end );
        node_pos = 2;
        for t = 2:t_end
            while( node(node_pos).quoteTime <= time( t ) && node_pos <= node_sz )
                node_pos = node_pos + 1;
            end
            node_pos = node_pos - 1;
            if node_pos <= node_sz
                val( t ) = node(node_pos).(feature);
                node_pos = node_pos + 1;
            end
            if node_pos > node_sz
                break;
            end
        end
    end
    
else
    
    start_pos = find( start_time < time );
    start_pos = start_pos( 1 );
    val(start_pos) = node(1).(feature);
    node_pos  = 2;
    if ( end_time - start_time < 1/24/60 )
        val(start_pos) = node(end).(feature);
    else
        t_end = find( end_time > time );
        t_end = t_end( end );
        for t = start_pos+1:t_end
            while( node(node_pos).quoteTime <= time( t ) && node_pos <= node_sz )
                node_pos = node_pos + 1;
            end
            node_pos = node_pos - 1;
            if node_pos <= node_sz
                val( t ) = node(node_pos).(feature);
                node_pos = node_pos + 1;
            end
            if node_pos > node_sz
                break;
            end
        end
    end
end

% ������ݽ���ȥ��
val(abs(val) < 0.0002-eps) = nan;

% �����ݽ��г�ʼֵȥnan
nan_idx = isnan(val);
opposite_nan_idx = find(~nan_idx);
if isempty(opposite_nan_idx)
else
    if nan_idx(1)
        first_value = val(opposite_nan_idx(1));
        for t = 1:opposite_nan_idx(1)-1
            val(t) = first_value;
        end
    end
end










end