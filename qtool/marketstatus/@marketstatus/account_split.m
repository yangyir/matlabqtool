function subacc = account_split(ori_account,Ind)
% ����ԭʼ��ʱ������ ori_account �Լ��ֶε�Ind������
% ��������ori_account(Ind)����ÿ�ΰ���һ�ε������ֵ���ֱ�������������С�
% ���Ϊһ������������ʽ
% by Zehui Wu version 1.0 2013/7/3

EndInd = find(diff(Ind)>=2);%ÿ������Ind�Ľ�����Ind��index
%����subacc���ڴ�
subacc = zeros(length(Ind),1);
if ~isempty(EndInd)
    %��һ��ֱ��ƽ��
    tmpsubacc = ori_account(Ind(1):Ind(EndInd(1)));
    subacc(1:length(tmpsubacc)) = tmpsubacc;
    endofsubacc = length(tmpsubacc)+1;
    %�ڶ����������ڶ��ε���
    for i = 2:length(EndInd)
%         tmpsubacc = ori_account(Ind(EndInd(i-1)+1):Ind(EndInd(i)))...
%             *subacc(endofsubacc-1)/ori_account(Ind(EndInd(i-1)+1));
        tmpsubacc = ori_account(Ind(EndInd(i-1)+1):Ind(EndInd(i)))...
            +subacc(endofsubacc-1)-ori_account(Ind(EndInd(i-1)+1));
        subacc(endofsubacc:endofsubacc+length(tmpsubacc)-1) = tmpsubacc;
        endofsubacc = endofsubacc+length(tmpsubacc);
    end
    %���һ�εĵ���
%     tmpsubacc = ori_account(Ind(EndInd(end)+1):Ind(end))...
%         *subacc(endofsubacc-1)/ori_account(Ind(EndInd(end)+1));
tmpsubacc = ori_account(Ind(EndInd(end)+1):Ind(end))...
         +subacc(endofsubacc-1)-ori_account(Ind(EndInd(end)+1));
    subacc(endofsubacc:end) = tmpsubacc;
else
    %û������
    subacc=ori_account;
end
%subacc�������
end