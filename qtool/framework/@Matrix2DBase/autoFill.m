function [ obj ] = autoFill( obj )
%check dimension OK
% -----------
% �̸գ�20150518�����汾����ɶȺܵ�

%%
% TODO: Ӧ���ȼ��yProps��xProps�Ƿ�����ͺ�����񣬸Ĺ���
[ T, y ]    = size(obj.yProps);
[ x, N ]    = size(obj.xProps); 
[M1, M2]    = size(obj.data);

% ��������жϣ��������dimension���ԣ�ת��
if T==1 && y>1
    warning('size(obj.yProps) = [%d, %d]; ת��Ϊ%d*%d', T,y, y,T);
    obj.yProps = transpose(obj.yProps);
end

if N==1 && x>1
    warning('size(obj.xProps) = [%d, %d]; ת��Ϊ%d*%d', x,N, N,x);
    obj.xProps = transpose(obj.xProps);
end

% ���ж��У�ֻȡһ�У�



if T==0 || N==0 || M1==0 ||M2==0
    warning('��δ��д����');
end

% ���ά�����
if T == M1 && N == M2
    sprintf('˫�򳤶��Ǻϣ�û�����⣡');
end

if T ~= M1 
    warning('���򳤶Ȳ��Ǻϣ�');
end

if N ~= M2
    warning('���򳤶Ȳ��Ǻϣ�');
end

%% ������TODO��Ҫ����ȷ����
obj.Ny = T;
obj.Nx = N;
    
    
end

