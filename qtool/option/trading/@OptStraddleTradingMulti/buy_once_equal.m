function buy_once_equal(obj, volume, offset, rangbu)
% ������Ȩ��buy_once
% buy_once_equal(obj, volume, offset, rangbu)
% ���Ʒ� 20161124

if ~exist('volume','var'),  volume = 1;   end
if ~exist('offset', 'var'), offset = '1'; end
if ~exist('rangbu', 'var'), rangbu = 1;   end
direc = '1';
call = obj.call;
put  = obj.put;
if isempty(call) || isempty(put)
    error('call����put��ԼΪ��')
end


% 1,����
assert(volume >= 1);
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('��OptStraddleTrading���,�޷�����')
    return;
end


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
proportion = ones(1, nCount);
optstratrade_object.openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);









end