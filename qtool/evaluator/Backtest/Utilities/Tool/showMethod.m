%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������Ϊ��data�����ݱ���nλС����ת��Ϊstring��
% ������Ҫע���������data��Ҫ��cell�͡�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataShow = showMethod( data,n )
      % data�������뱣��nλС��
      data = cell2mat(data);
      m = size(data,1);
      n0 = size(data,2);
      nTen = 10^n;
      dataShow = round(data*nTen)/nTen;
      mdiv = ones(1,m);
      ndiv = ones(1,n0);
      dataShow  = mat2cell(dataShow,mdiv,ndiv);
      for i =1:m
          for j=1:n0
              dataShow{i,j} = num2str(dataShow{i,j});
              [~,remain] = strtok(dataShow{i,j},'.');
                % ����nλС����0
              if isempty(remain)
                  afterSeq = zeros(1,n);
                  afterSeq = num2str(afterSeq);
                  afterSeq(afterSeq==' ') = '';
                  dataShow{i,j} = strcat(dataShow{i,j},'.',afterSeq);
              elseif length(remain)<n+1
                  afterSeq = zeros(1,n+1-length(remain));
                  afterSeq = num2str(afterSeq);
                  dataShow{i,j} = strcat(dataShow{i,j},afterSeq);
              end
          end
      end
end
