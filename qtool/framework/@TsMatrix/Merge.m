function mergedTsm = Merge(tsm1, tsm2)
%TSM_MERGE merges mat1 and mat2 
% theorically, no means to get perfect new mat.
% this function does its best to include every info in mat1 and mat2
% one thing missing: compare when mat1 and mat2 overlaps.
%

if nargin ~= 2 return; end
if ~isa(tsm1,'TsMatrix') || ~isa(tsm2,'TsMatrix') return; end
if ~strcmp(tsm1.datatype, tsm2.datatype) return; end

    mergedTsm = TsMatrix; 
    mergedTsm.datatype = tsm1.datatype;
    mergedTsm.des = 'Merged';
    
    %% UPDATE mergedMat.dates
    dt1 = tsm1.dates; dt2 = tsm2.dates;
    [new_1_dt_idx,old_1_dt_idx,dt] = mergeNewIdx(dt1, dt2);
    [new_2_dt_idx,old_2_dt_idx   ] = mergeNewIdx(dt2, dt1);
    
    mergedTsm.dates = dt;
    
    
    %assets
    cd1 = tsm1.assets(1,:);   cd2 = tsm2.assets(1,:);
    
    [ new_1_cd_idx,old_1_cd_idx] = mergeNewIdx(cd1, cd2);
    [ new_2_cd_idx,old_2_cd_idx] = mergeNewIdx(cd2, cd1);
    
    %% update mergedMat.data
    % violently insert whole mat1 into result 
    data(new_1_dt_idx,new_1_cd_idx) = tsm1.data(old_1_dt_idx, old_1_cd_idx);

    %violently insert whole mat2 into result
    data(new_2_dt_idx,new_2_cd_idx) = tsm2.data(old_2_dt_idx, old_2_cd_idx);
    
    mergedTsm.data = data;
    
    
    %% update mergedMat.assets
     % 稍微费力一些，因为assets不是一维的
    cd1 = tsm1.assets(1,:);cd2 = tsm2.assets(1,:);

    %记录index，供还原用
    len1 = length(cd1); len2 = length(cd2);
    idx10 = [(1:len1), zeros(1,len2)];
    idx20 = [zeros(1,len1) , (1:len2)];
    oriidx = [idx10; idx20];

     %合并，唯一，排序，记录
    cd = [cd1, cd2];
    [cd,ia,ic] = unique(cd);
    [cd,id] = sort(cd);
   
    final_asset_idx = oriidx(:, ia(id));
    
    %合并assets
    As1_Idx = final_asset_idx(1,:);
    x1 = find( As1_Idx >0 );

    As2_Idx = final_asset_idx(2,:);
    x2 = find( As2_Idx >0 );

    as(:,x1) = tsm1.assets(:,As1_Idx(x1));
    as(:,x2) = tsm2.assets(:,As2_Idx(x2));

    mergedTsm.assets = as;
    
end


    

