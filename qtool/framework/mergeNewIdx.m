function [ new_idx, old_idx, mergedVector ] = mergeNewIdx( vector1,vector2 )
%OLD2NEWIDX vec1 and vec2 are old vectors, 
%merged (and ordered) vec is the new vector.
%returns index of old and new vectors so that
%vec(new_idx) = vec1(old_idx) includes whole vec1
%very useful for date series merge
% vector1      
% vector2
% old_idx
% new_idx
% $Date 2013/2/27 $Author Cheng,Gang $
    
    %check size
    s1 = size(vector1); s2 =size(vector2);
    if s1(1)==1 & s2(1)==1  
        type='horizontal'; %  1*N
    elseif s1(2)==1 & s2(2)==1  
        type='vertical'; % N*1
    else
        return
    end
    
    
    % Merge
    [vec2d1, idx2d1] = setdiff(vector2,vector1);
    len1 = length(vector1);
    len2d1 = length(vec2d1);
    
    if strcmp(type, 'vertical')
        mergedVector = [vector1; vec2d1];
        idx = [1:len1 zeros(1,len2d1)]';
    elseif strcmp(type, 'horizontal')
        mergedVector = [vector1, vec2d1];
        idx = [1:len1 zeros(1,len2d1)];
    end
    
    [mergedVector,ia,ic] = unique(mergedVector);
    [mergedVector, id ] = sort(mergedVector);

    old_idx = idx(ia(id));    
    new_idx = find( old_idx >0 ); 
    
    %remove zeros from old_idx
    old_idx = old_idx(new_idx);
    
end

