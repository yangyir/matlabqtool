function obj  = setSig(obj, ind2sig, varargin)
% obj.setSig(@func, 'param', var_param, 'idx', var_idx);
% convert ind to sig
% idx: index of ind that convert to sig by ind2sig.
% sig 必须是可数可列
%————————————————
% daniel @20140925 note: add idx that specify range of indicator used.
% daniel @20140915

if nargin ==1 || ~exist('ind2sig','var'), ind2sig = @sign;end

varlist = {'param','idx','tag'};

if nargin >= 3 
    varname = varargin(1:2:end);
    var     = varargin(2:2:end);

    if length(varname) ~= length(var)
        error('wrong inputs');
    end

    [isflag,~]=ismember(varname,varlist) ;

    if sum(isflag) ~= length(varname)
        error('参数名不对，请查看帮助参数名列表');
    end ;

    for iVar = 1:length(varname)
        eval([ varname{iVar}, '= var{iVar} ;'  ]);
    end
end


if ~exist('idx', 'var'), idx = 1:length(obj.indName);end

% 

if isempty(obj.sigVal)
    init_p = 1;
else
    init_p = size(obj.sigVal,2)+1;
end


% 转换指标到信号
if ~exist('param','var')
    % 无变量输入
    obj.sigVal(:,init_p:init_p+length(idx)-1) = ind2sig(obj.indVal(:,idx));
    obj.mapSig2Ind(1,init_p:init_p+length(idx)-1) = idx;
else
    obj.sigVal(:,init_p:init_p+length(idx)-1) = ind2sig(obj.indVal(:,idx), param);
    obj.mapSig2Ind(1,init_p:init_p+length(idx)-1) = idx;
end

% 信号取值
if ~exist('tag','var')
    tag = unique(obj.sigVal(:,init_p:init_p+length(idx)-1));
    tag(tag==0)= []; %如果tag为空则说明没有有效信号
    if length(tag)>10
        warning('too many signal values to test');
    end
end

% 记录信号转换方法，记录信号和指标间的关系
if isempty(obj.sigName)
    obj.sigName{1,1} = func2str(ind2sig);
    obj.sigName{2,1} = tag;
    obj.mapSig2Ind(2,init_p:init_p+length(idx)-1) = size(obj.sigName,2);
else
    nCol = size(obj.sigName,2);
    obj.sigName{1,nCol+1} = func2str(ind2sig);    
    obj.sigName{2,nCol+1} = tag;
    obj.mapSig2Ind(2,init_p:init_p+length(idx)-1) = size(obj.sigName,2);
end



