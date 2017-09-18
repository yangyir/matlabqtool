function [merged_array] = merge_two_position_array(src_arr, dst_arr)
%function [merged_array] = merge_two_position_array(src_arr, dst_arr)
% 合并两个PositionArray,保持原两个Array不变，返回一个新Array
    merged_array = PositionArray;
    src_L = length(src_arr.node);
    dst_L = length(dst_arr.node);
    for i = 1:src_L
        p = src_arr.node(i);
        merged_array.try_merge_ifnot_push(p);
    end
    
    for j = 1:dst_L
        p = dst_arr.node(j);
        merged_array.try_merge_ifnot_push(p);
    end
end