function [ varargout ] = chg0( nday,varargin )
%   chg0 give the change   of a sequence
%   nday         ����n���ǵ�����nday>0ǰ�飬nday<0����
%   varargin     time sequence
%version 1.0, luhuaibao, 20140603

nseq = length(varargin);
for i = 1:nseq
    if nday>0
        seq = varargin{i};
 
        %% ����diff(seq)��ǰ��nday��

        seq1 = seq(nday+1:end);
        diff_seq = seq1 - seq(1:end-nday);
        varargout{i} = diff_seq ; 
        %%
        if size(seq,1) < size(seq,2)
            mat0 = zeros(1,nday);
            varargout{i} = horzcat(mat0,varargout{i});
        else
            mat0 = zeros(nday,1);
            varargout{i} = vertcat(mat0,varargout{i});
        end

        
    end
    
    if nday<0
        seq = varargin{i};
 
        %% ����diff(seq)������nday��

        seq1 = seq(1:end+nday);
        diff_seq = seq(1-nday:end)-seq1;
        varargout{i} = diff_seq ;  

        %%
        if size(seq,1) < size(seq,2)
            mat0 = zeros(1,-nday);
            varargout{i} = horzcat(varargout{i},mat0);
        else
            mat0 = zeros(-nday,1);
            varargout{i} = vertcat(varargout{i},mat0);
        end

             
    end
    
end

end