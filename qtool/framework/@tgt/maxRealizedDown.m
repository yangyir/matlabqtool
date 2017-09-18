function [ score ] = maxRealizedDown( inSeq, varargin )
%% maxRealizedDown calculate maximum realized loss.
% [ score ] =  maxRealizedDown( inSeq )
% returns maximum realized logarithmic drop ratio.
%
% [ score ] =  maxRealizedDown( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary growth rate will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  maxRealizedDown( inSeq, N )
% returns maximum realized logarithmic drop ratio in the last N time
% slices.
% N should be a positive integer
%
% [ score ] =  maxRealizedDown( inSeq, N, MODE )
% ----------------------------------------------------
% ver1.0;   Cheng,Gang;     20130418

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
min = min_past_sequ(inSeq,N);

if strcmp(mode,'d')
    score   = min/inSeq(N) -1;
elseif strcmp(mode,'c')
    score   = log(min/inSeq(N));
else
    error('Use ''c'' or ''d'' only to specify mode.');
end




end

