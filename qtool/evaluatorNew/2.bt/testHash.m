% 以下代码功能为：统计文本中单词出现的次数（包括数字，但不包括标点）
text ='In computing, a hash table (also hash map) is a datastructure used to implement an associative array, a structure that can map keysto values. A hash table uses a hash function to compute an index into an arrayof buckets, from which the correct value can be found.';
word_cell = regexp(text,'\w+','match');% 使用正则表达式分割文本中的字符
word_ht = java.util.Hashtable;% 生成哈希表的对象
% 遍历文本单词cell，并统计单词出现次数
for ii =1: length(word_cell)
    lower_word = lower(word_cell{ii});% 转换为小写字符
    if word_ht.containsKey(lower_word)% 单词是否已在关键字列表中
        word_ht.put(lower_word, word_ht.get(lower_word)+1);% 使用 ht.put(key, value) 将单词及其出现次数保存到哈希表中
    else
        word_ht.put(lower_word,1);
    end
end
word_list = word_ht.keys;% 获取关键字列表
% 输出所有单词及其出现次数（并无排序）
while( word_list.hasNext )% word_list.hasNext为真说明下一个元素存在，否则已遍历到列表尾
    word = word_list.nextElement;% 获取下一个关键字
    fprintf('%s : %d\n', word, word_ht.get(word)); % 使用 ht.get(key) 可得到key对应的value，即 value = ht.get(key)
end