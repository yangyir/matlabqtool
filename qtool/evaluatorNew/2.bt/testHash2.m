
%% 试用HashTable
ht = java.util.Hashtable;% 生成哈希表的对象

ht.put('price', 10);
ht.put('volume', 230943);


keyList = ht.keys;% 获取关键字列表
% 输出所有单词及其出现次数（并无排序）
while( keyList.hasNext )% 为真说明下一个元素存在，否则已遍历到列表尾
    key = keyList.nextElement;% 获取下一个关键字
    fprintf('%s : %d\n', key, ht.get(key)); % 使用 ht.get(key) 可得到key对应的value，即 value = ht.get(key)
end