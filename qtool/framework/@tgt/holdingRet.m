function [ score ] = holdingRet( inSeq, varargin )
%% holdingRet calculate realized return starting from N slices before (or beginning of this time sequence).
% [ score ] =  holdingRet( inSeq )
% returns realized logarithmic return starting from N slices before.
%
% [ score ] =  holdingRet( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary return will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  holdingRet( inSeq, N )
% returns realized logarithmic return starting from N slices before.
% N should be a positive integer
%
% [ score ] =  holdingRet( inSeq, N, MODE )

% Qichao Pan, 20130417, 20:42, GMT+8, v1.0
% Qichao Pan, 20130422, 14:47, GMT+8, v2.0
%   adjusted structure, process input parameters first, then perform
%   computation.
%%
if nargin == 1
    N = 0;
    mode = 'c';
elseif nargin == 2
    if isa(varargin{1},'char')
        mode = varargin{1};
        N = 0;
    elseif isa(varargin{1},'double')
        N = varargin{1};
        mode = 'c';
    end
elseif nargin == 3
    N = varargin{1};
    mode = varargin{2};
else
    error('too many input arguments!');        
end
%%
score = nan(size(inSeq));
if isa(N,'double')&&isa(mode,'char')
    if length(inSeq)<=N
        error('Watch time is longer than sequence time!');
    end
    if strcmp(mode,'d')
        if N == 0
            score = inSeq./inSeq(1)-1;
        else
            score(N+1:end) = inSeq(N+1:end)./inSeq(1:end-N)-1;
            score(1:N) = inSeq(1:N)./inSeq(1)-1;
        end
    elseif strcmp(mode,'c')
        if N ==0
            score = log(inSeq./inSeq(1));
        else
            score(N+1:end) = log(inSeq(N+1:end)./inSeq(1:end-N));
            score(1:N) = log(inSeq(1:N)./inSeq(1));
        end
    else
        error('Use ''c'' or ''d'' only to specify mode.');
    end            
else
    error('input argument type error!');
end

end

