classdef HistoricOptQuoteStore < ArrayBase
    % HistoricQuoteStore 存储一段定长的历史行情数据。
    % 在实测之后，若性能有影响，应改为定长数组。
    properties
        node = QuoteOpt;
        optCode@char;
        optName@char;
        currentDate;
        day_pos;
        current_start_pos@double = 0;
        current_end_pos@double = 0;
    end
    
    
    methods        
        function [obj] = HistoricOptQuoteStore(opt_code, opt_name)
            if ~exist('opt_code', 'var')
                opt_code = '00000000';
            end
            
            if ~exist('opt_name', 'var')
                opt_name = '无名期权';
            end
            obj.optCode = opt_code;
            obj.optName = opt_name;            
            obj.node = QuoteOpt;            
            obj.currentDate = today;
            day_pos = 0;
            current_start_pos = 0;
            current_end_pos = 0;
        end
        
        function set.optCode(self, opt_code)
            if isa(opt_code, 'char')
                self.optCode = opt_code;
            else
                warning('赋值失败：类型错误！');
            end
        end
        
        function set.optName(self, opt_name)
            if isa(opt_name, 'char')
                self.optName = opt_name;
            else
                warning('赋值失败：类型错误！');
            end
        end
        
        function set.node(self, node)
            if isa(node, 'QuoteOpt')
                code = node(end).code;
                if (strcmp(code, self.optCode))
                    self.node = node;
                else
                    % 针对load时清空的情况打补丁，这里有点丑，不过没想到好方法。
                    if 0 == self.latest
                        node.code = self.optCode;
                        node.optName = self.optName;
                    else
                        warning('赋值失败，非指定合约');
                    end
                end
            else
                warning('赋值失败：类型错误！');
            end
        end
        
        function [success] = UpdateQuote(obj, quote)
            % 检查时间戳
            % 对比末尾时间戳和当前时间戳，若有变化，认为是有效更新。
            success = 0;
            if ~strcmp(obj.node(end).quoteTime, quote.quoteTime)
                q = quote.getCopy();
                q.quoteTime = now;
                obj.push(q);                
                obj.addto_end_pos(1);
                success = 1;
            end
        end
        
        function [] = atomic_settle_prev_pos(obj, num)
            % 维护插入往日数据时的读写指针维护
            obj.current_start_pos = obj.current_start_pos + num;
            obj.current_end_pos = obj.current_end_pos + num;
        end
        
        function [] = addto_end_pos(obj, num)
            if obj.current_start_pos == 0
                obj.current_start_pos = 1;
            end
            obj.current_end_pos = obj.current_end_pos + num;
        end
        
        function merge_prev_quote(obj, prev_store)
            % 存入之前日的行情序列
            if obj.check_same_asset(prev_store)
                L = length(prev_store);
                obj.push_front(prev_store.node);
            end
        end
        
        function [] = save_currentday_quote(obj, file_name)
            % 取当日的行情，存入文件中。
            obj.toExcel(file_name, 'historic_quote', obj.current_start_pos, obj.current_end_pos);
        end
        
        function [same_asset] = check_same_asset(obj, other)
            same_asset = strcmp(obj.optCode, other.optCode) && strcmp(obj.optName, other.optName);
        end
        
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '无名期权'));
        end

        
        % 提供重载的ToTable
        % toFile
        % fromTable
        function [obj] = fromFile(obj, file_name)
            % file 的结构应该为：品种作为目录名，日期作为品种目录下的文件名
            % 先寻找代码，再判断时间，再构造行情
            obj.fromExcel(file_name);
        end
        
        function [] = toFile(obj, file_name)
            % 以品种名为目录，日期作为文件名来存储
            obj.toExcel(file_name);
        end
        
        % 应该提供对于行情序列的相关操作，例如画图等。
        function plot_impvol(obj)
            plot([obj.node.impvol]);
        end
    end
end