% ���´��빦��Ϊ��ͳ���ı��е��ʳ��ֵĴ������������֣�����������㣩
text ='In computing, a hash table (also hash map) is a datastructure used to implement an associative array, a structure that can map keysto values. A hash table uses a hash function to compute an index into an arrayof buckets, from which the correct value can be found.';
word_cell = regexp(text,'\w+','match');% ʹ��������ʽ�ָ��ı��е��ַ�
word_ht = java.util.Hashtable;% ���ɹ�ϣ��Ķ���
% �����ı�����cell����ͳ�Ƶ��ʳ��ִ���
for ii =1: length(word_cell)
    lower_word = lower(word_cell{ii});% ת��ΪСд�ַ�
    if word_ht.containsKey(lower_word)% �����Ƿ����ڹؼ����б���
        word_ht.put(lower_word, word_ht.get(lower_word)+1);% ʹ�� ht.put(key, value) �����ʼ�����ִ������浽��ϣ����
    else
        word_ht.put(lower_word,1);
    end
end
word_list = word_ht.keys;% ��ȡ�ؼ����б�
% ������е��ʼ�����ִ�������������
while( word_list.hasNext )% word_list.hasNextΪ��˵����һ��Ԫ�ش��ڣ������ѱ������б�β
    word = word_list.nextElement;% ��ȡ��һ���ؼ���
    fprintf('%s : %d\n', word, word_ht.get(word)); % ʹ�� ht.get(key) �ɵõ�key��Ӧ��value���� value = ht.get(key)
end