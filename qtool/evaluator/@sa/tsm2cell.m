function cel = tsm2cell( tsm )
%TSM_2CELL transfer a TsMatrix or SingleAsset object back to a cell.
%One can then getmatrix from excel
%         X1     X2
% Y1            assets
% Y2    dates   data
% $Author Cheng,Gang $ver 0.2  $Date 2013/3/4

%% pre-processing
if nargin ~= 1 return; end
if isa(tsm,'TsMatrix') 
    [Y1,X2] = size( tsm.assets);
elseif isa(tsm,'SingleAsset') 
    [Y1,X2] = size( tsm.tstypes);
else
    return; 
end

[Y2,X1] = size(tsm.dates);
cel = cell(Y1+Y2 , X1+X2);

%% assets / tstypes 2 cell
if isa(tsm, 'TsMatrix')
    cel{1,1} = tsm.des;
    cel{2,1} = tsm.datatype;
    if iscell( tsm.assets )
        cel(1:Y1, X1+1:X1+X2) = tsm.assets;
    end
elseif isa( tsm, 'SingleAsset')
    cel{1,1} = tsm.assetname;
    cel{2,1} = tsm.assetcode;
    if iscell( tsm.tstypes)
        cel(1:Y1, X1+1:X1+X2) = tsm.tstypes;
    end
end


%% dates 2 cell
if isa( tsm.dates, 'double')
    cel(Y1+1:Y1+Y2,1:X1) = cellstr(datestr(tsm.dates,26));
end

%% data 2 cell
if isa( tsm.data, 'double')
    cel(Y1+1:Y1+Y2, X1+1:X1+X2) = num2cell(tsm.data);
end



end

