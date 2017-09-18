function [ score ] = potentialRet( inSeq,varargin )
%% potentialRet calculate potential return by the end of next N slices(or end of this time sequence).
% [ score ] =  potentialRet( inSeq )
% returns potential logarithmic return by the end of time series.
%
% [ score ] =  potentialRet( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary return will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  potentialRet( inSeq, N )
% returns potential logarithmic return in the next N time slices.
% N should be a positive integer
%
% [ score ] =  potentialRet( inSeq, N, MODE )

% Qichao Pan, 20130407, 11:23, GMT+8, v1.0
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
            score = inSeq(end)./inSeq-1;
        else
            score(1:end-N) = inSeq(N+1:end)./inSeq(1:end-N)-1;
            score(end-N+1:end) = inSeq(end)./inSeq(end-N+1:end)-1;
        end
    elseif strcmp(mode,'c')
        if N == 0
            score = log(inSeq(end)./inSeq);
        else
            score(1:end-N) = log(inSeq(N+1:end)./inSeq(1:end-N));
            score(end-N+1:end) = log(inSeq(end)./inSeq(end-N+1:end));
        end
    else
        error('Use ''c'' or ''d'' only to specify mode.');
    end            
else
    error('input argument type error!');
end

end

