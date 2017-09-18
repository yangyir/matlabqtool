function sell_once(obj, volume, offset, rangbu)
% sell_once(obj, volume, offset, rangbu, proportion)
% ��OptStraddleTrading�����µ�����
% Ĭ�ϰ���proportion���ж�������µ�, volume�ǵ�λ���µ�����


if ~exist('volume','var'),  volume = 1;   end
if ~exist('offset', 'var'), offset = '1'; end
if ~exist('rangbu', 'var'), rangbu = 1;   end
call = obj.call;
put  = obj.put;
if isempty(call) || isempty(put)
    error('call����put��ԼΪ��')
end
direc = '2';


% 1,�ж�
assert(volume >= 1);
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('��OptStraddleTrading���,�޷�����')
    return;
end


% 2,���õı���
proportion = obj.proportion;
if length(proportion) == nCount
    if any(isnan(proportion)) % ���ֵ�ڴ���Nan
        warning('�µ����ʴ���nan,���õȱ����µ�')
        proportion = ones(1, nCount);
        obj.proportion = proportion;
    end
else
    warning('���յȱ����µ�size����,���õȱ����µ�')
    proportion = ones(1, nCount);
    obj.proportion = proportion;
end
proportion = round(proportion);
assert(all(proportion >= 0))



% 2,����ί���µ�����
keys_value = obj.keys;
for straddle_t = 1:nCount
    optstratrade_object = get(obj, keys_value{straddle_t});
    if straddle_t == 1
        ctrs  = {optstratrade_object.counter};
        books = optstratrade_object.book;
    else
        ctrs{end + 1}  = optstratrade_object.counter;
        books(end + 1) = optstratrade_object.book;
    end
end
optstratrade_object.openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);









end