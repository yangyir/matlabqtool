function   [sigReport] = testSig(obj, evalSig, varargin)
% evalSig, param 为传方法和传参数
% evalSig 可参照defaultEval函数写，可用sig内的所有信息
% param必须含有 nStep和overlap域
% ------------
% huajun @20140916

if nargin == 1 || ~exist('evalSig','var'), evalSig = @defaultEval; end

varlist = {'param','idx'};

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

if ~exist('idx','var'), idx = 1:size(obj.sigVal,2);end
if ~exist('param','var')
    % default setup of param;
    param.nStep = 1;
    param.overlap = 1;
end


%%
sigReport.value = [];
sigReport.name  = '';
sigReport.catagory = {};
sigReport.catTitle = {'Ind','ind2sig','tag'};
iRow = 1;

for iSig = 1:length(idx)
    iCol = idx(iSig);
    tag = obj.sigName{2,obj.mapSig2Ind(2,iCol)};
    sigName = obj.sigName{1,obj.mapSig2Ind(2,iCol)};
    indName = obj.indName{1,obj.mapSig2Ind(1,iCol)};
    
    if ~isempty(tag)
        for jTag = 1:length(tag)
            idxSig = find(obj.sigVal(:,iCol) == tag(jTag));
            
            if ~isempty(idxSig)
                
                if iRow ==1
                    [sigReport.value,sigReport.name   ] = evalSig(obj, idxSig, param);
                else
                    sigReport.value(iRow,:) = evalSig(obj,idxSig,param);
                end
                sigReport.catagory{iRow,1}= indName;
                sigReport.catagory{iRow,2}= sigName;
                sigReport.catagory{iRow,3}= tag(jTag);
                iRow = iRow+1;
            end
        end
    end
    
  
end
end % end of testSig


