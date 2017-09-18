function [ score ] = maxPotentialDown( inSeq,varargin)
%% maxPotentialDown calculate maximum potential loss.
% [ score ] =  maxPotentialDown( inSeq )
% returns maximum potential logarithmic drop ratio.
%
% [ score ] =  maxPotentialDown( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary growth rate will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  maxPotentialDown( inSeq, N )
% returns maximum potential logarithmic drop ratio in the next N time
% slices.
% N should be a positive integer
%
% [ score ] =  maxPotentialDown( inSeq, N, MODE )

% Qichao Pan, 20130417, 11:23, GMT+8, v1.0
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
        lowFuture = min_future_sequ(inSeq);
    else
        lowFuture = min_future_sequ(inSeq,N);
    end

    if strcmp(mode,'d')
        score = lowFuture./inSeq -1;
    elseif strcmp(mode,'c')
        score = log(lowFuture./inSeq);
    else
        error('Use ''c'' or ''d'' only to specify mode.');
    end            
else
    error('input argument type error!');
end


end
