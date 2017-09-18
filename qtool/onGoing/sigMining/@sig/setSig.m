function obj  = setSig(obj, ind2sig, varargin)
% obj.setSig(@func, 'param', var_param, 'idx', var_idx);
% convert ind to sig
% idx: index of ind that convert to sig by ind2sig.
% sig �����ǿ�������
%��������������������������������
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
        error('���������ԣ���鿴�����������б�');
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


% ת��ָ�굽�ź�
if ~exist('param','var')
    % �ޱ�������
    obj.sigVal(:,init_p:init_p+length(idx)-1) = ind2sig(obj.indVal(:,idx));
    obj.mapSig2Ind(1,init_p:init_p+length(idx)-1) = idx;
else
    obj.sigVal(:,init_p:init_p+length(idx)-1) = ind2sig(obj.indVal(:,idx), param);
    obj.mapSig2Ind(1,init_p:init_p+length(idx)-1) = idx;
end

% �ź�ȡֵ
if ~exist('tag','var')
    tag = unique(obj.sigVal(:,init_p:init_p+length(idx)-1));
    tag(tag==0)= []; %���tagΪ����˵��û����Ч�ź�
    if length(tag)>10
        warning('too many signal values to test');
    end
end

% ��¼�ź�ת����������¼�źź�ָ���Ĺ�ϵ
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



