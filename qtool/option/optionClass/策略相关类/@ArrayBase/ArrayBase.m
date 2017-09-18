classdef(Abstract) ArrayBase < handle
    %ARRAYBASE ������ࣨ�����ࣩ��һ���أأط�һ��
    % ʹ�÷�����
%         classdef DataArray < ArrayBase
%             node = DataClass  % ��node���廯��ĳ��������
%             function set.node
    % ------------------------------------  
    % �̸գ�20160204
    % cg, 20160224, �޸�push���������ӶԵ�һ��Ԫ�صĴ���
    % cg, 161017, �޸ķ����� clear_array(obj)
    % cg, 1703, ���뷽����  [obj] = insertByIndex(obj, i, onenode)
    
    
    properties
        latest@double   = 0 ;       % 
        capacity@double = 1000;     %
        isSorted        = 0;        % ����1�� ���� -1�� ���� 0.
    end
    
    % ����ģ���Ҫ�������о��廯
    properties(Abstract = true, SetAccess = public, GetAccess = public)
        node;    
    end
    
    
    properties(Hidden = true)
        headers@cell;
        table@cell;
%         data;
    end


    
    methods
        function [obj] = push(obj, node)
           
            lat = obj.latest;
            lat = lat + 1;            
            try
                if lat == 1 % �ӿշ����һ����Ҫ�ر���
                    obj.node = node;
                else
                    obj.node(lat) = node;
                end
                obj.latest = lat;
            catch e
                fprintf('push(node)ʧ�ܣ�%s', class(node));
            end
        end
        
        
          % ��iλ�ò���onenode�� ԭi:endλ˳�κ���
        function [obj] = insertByIndex(obj, i, onenode)
            
            lat = obj.latest;
%             lat = lat + 1;
            if i<=0
                error('����λi<=0,');
                return;
            end
                
            if i> lat % 
                warning('����λ��ԭarray������������');
                obj.push(onenode);
            else
                obj.node(i+1:lat+1) = obj.node(i:lat);
                obj.node(i) = onenode;                
                obj.latest = lat + 1;
            end
            
        end
         
        
        function [obj] = push_front(obj, nodes)
            L = length(nodes);
            lat = obj.latest;
            try
                if lat == 0
                    obj.node = nodes;
                else
                    obj.node = [nodes, obj.node];
                end
                obj.latest = lat + L;
            catch e
                fprintf('push(node)ʧ�ܣ�%s', class(nodes));
            end
        end
        
        function [ node ] = removeByIndex(obj, i) 
            
            % ��catch��һ�д��󶼴����: isempty, isnan, ��������,etc
            try                
                % �Ƴ�
                node = obj.node(i);
                obj.node(i) = [];
                obj.latest = obj.latest - 1;
            catch e
                warning('Array.removeByIndex����ʧ��');
            end
            
        end
        
        
      
        % �������array�� ��������Ȼ����
        function [obj] = clear_array(obj)
            try
                obj.latest = 0;
%                 obj.node = [];
                classname = class(obj.node);
                eval(['obj.node = ' classname ';']);
            catch
                warning('ArrayBase.clear_array����ʧ��');
            end
        end
        
        % �ж��Ƿ�Ϊ��
        function [ret] = isempty(obj)
            if obj.latest == 0
                ret = true;
            else                
                ret = false;
            end
        end
        
        % ��һ��ӡnode����Ҫ������node.println����
        [txt] = print(obj);
        
        [ table, flds ] = toTable(obj, start_pos, end_pos);
        [ filename ] = toExcel(obj, filename, sheetname, start_pos, end_pos);        
        
        % �����е�obj����excel���ݣ�className������ȽϺý��
        [obj] = loadExcel(obj, filename, sheetname);
        
        
    end
    
end

