
%% ����HashTable
ht = java.util.Hashtable;% ���ɹ�ϣ��Ķ���

ht.put('price', 10);
ht.put('volume', 230943);


keyList = ht.keys;% ��ȡ�ؼ����б�
% ������е��ʼ�����ִ�������������
while( keyList.hasNext )% Ϊ��˵����һ��Ԫ�ش��ڣ������ѱ������б�β
    key = keyList.nextElement;% ��ȡ��һ���ؼ���
    fprintf('%s : %d\n', key, ht.get(key)); % ʹ�� ht.get(key) �ɵõ�key��Ӧ��value���� value = ht.get(key)
end