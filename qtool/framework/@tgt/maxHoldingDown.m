function [ score ] = maxHoldingDown( inSeq, varargin )
%% maxHoldingDown calculate maximum realized loss.
% [ score ] =  maxHoldingDown( inSeq )
% returns maximum realized logarithmic drop ratio.
%
% [ score ] =  maxHoldingDown( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary growth rate will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  maxHoldingDown( inSeq, N )
% returns maximum realized logarithmic drop ratio in the last N time
% slices.
% N should be a positive integer
%
% [ score ] =  maxHoldingDown( inSeq, N, MODE )

% Qichao Pan, 20130418, 10:00, GMT+8, v1.0
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
if isa(N,'double')&&isa(mode,'char')
    if N == 0
        highPast = max_hold_sequ(inSeq);
    else
        highPast = max_hold_sequ(inSeq,N);
    end
    if strcmp(mode,'d')
        score = inSeq./highPast -1;
    elseif strcmp(mode,'c')
        score = log(inSeq./highPast);
    else
        error('Use ''c'' or ''d'' only to specify mode.');
    end            
else
    error('input argument type error!');
end
end

