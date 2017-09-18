function [ obj ] = autoFill( obj )
%check dimension OK
% -----------
% 程刚，20150518，初版本，完成度很低

%%
% TODO: 应该先检查yProps和xProps是否纵向和横向，如否，改过来
[ T, y ]    = size(obj.yProps);
[ x, N ]    = size(obj.xProps); 
[M1, M2]    = size(obj.data);

% 最初步的判断，如果行列dimension不对，转置
if T==1 && y>1
    warning('size(obj.yProps) = [%d, %d]; 转置为%d*%d', T,y, y,T);
    obj.yProps = transpose(obj.yProps);
end

if N==1 && x>1
    warning('size(obj.xProps) = [%d, %d]; 转置为%d*%d', x,N, N,x);
    obj.xProps = transpose(obj.xProps);
end

% 如有多行？只取一行？



if T==0 || N==0 || M1==0 ||M2==0
    warning('尚未填写完整');
end

% 检查维数相等
if T == M1 && N == M2
    sprintf('双向长度吻合，没有问题！');
end

if T ~= M1 
    warning('纵向长度不吻合！');
end

if N ~= M2
    warning('横向长度不吻合！');
end

%% 填数，TODO：要填正确的数
obj.Ny = T;
obj.Nx = N;
    
    
end

