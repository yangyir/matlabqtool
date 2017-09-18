function [ score ] = realizedRet( inSeq, varargin )
%% realizedRet 算从第N步到现在的收益
% [ score ] =  realizedRet( inSeq )
% returns realized logarithmic return starting from N slices before.
%
% [ score ] =  realizedRet( inSeq, MODE )
% MODE is optional. It decides if logarithmic or ordinary return will
% be used.
%   'c' logarithmic or continuous;
%   'd' oridnary or discrete;
%
% [ score ] =  realizedRet( inSeq, N )
% returns realized logarithmic return starting from slice N.
% N should be a positive integer
%
% [ score ] =  realizedRet( inSeq, N, MODE )
% -----------------------------------------------------------------
% Qichao Pan, 20130417, 20:42, GMT+8, v1.0
% Cheng,Gang; 20130419; v1.1; 修正概念

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

if strcmp(mode,'d')
    score   = inSeq/inSeq(N) -1;
elseif strcmp(mode,'c')
    score   = log(inSeq/inSeq(N));
else
    error('Use ''c'' or ''d'' only to specify mode.');
end




end

