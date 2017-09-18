function [ score ] = maxRealizedUp( inSeq, varargin )
%% maxRealizedUp calculate maximum realized profit.
% [ score ] =  maxRealizedUp( inSeq )
% returns maximum realized logarithmic up ratio.
%
% [ score ] =  maxRealizedUp( inSeq, mode )
% MODE is optional. It decides if logarithmic or ordinary growth rate will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  maxRealizedUp( inSeq, N )
% returns maximum realized logarithmic up ratio in the past N time
% slices.
% N should be a positive integer
%
% [ score ] =  maxRealizedUp( inSeq, N, mode )
% ------------------------------------------------------------------------
% v1.0;     Cheng,Gang;     20130418;


%% pre-process
if nargin == 2
    if isa(varargin{1},'char')
        mode    = varargin{1};
    elseif isa(varargin{1},'double')
        N       = varargin{1};
    end
elseif nargin ==3
    if isa(varargin{1},'double') && isa(varargin{2},'char')
        N       = varargin{1};
        mode    = varargin{2};
    else
        error('input argument type error!');
    end
elseif nargin > 3
    error('too many input arguments!');    
end

if ~exist('mode', 'var') mode = 'c'; end
if ~exist('N', 'var' )    N   = 1;   end


%% main
max = max_past_sequ(inSeq,N);

if strcmp(mode,'d')
    score   = max/inSeq(N) -1;
elseif strcmp(mode,'c')
    score   = log(max/inSeq(N));
else
    error('Use ''c'' or ''d'' only to specify mode.');
end



end

