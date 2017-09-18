classdef HistoricQuoteM2TK < M2TK
    properties
        currentDate = today;
        step@double = 4;
    end
    
    methods
        function [obj] = HistoricQuoteM2TK(des)
            % ���캯��, desΪ��������
            % [obj] = OptionOneM2TK(des)
            obj = obj@M2TK(des) ;
            obj.data = HistoricOptQuoteStore;
        end
        
        function [obj] = init_by_quote_mat(obj, quote_m2tk)
            if isa(quote_m2tk, 'M2TK')
                nT = length(quote_m2tk.yProps);
                nK = length(quote_m2tk.xProps);
                
%                 obj = quote_m2tk.getCopy();
                flds = fields(quote_m2tk);
                L = length(flds);
                for i = 1:L
                    try
                        obj.(flds{i}) = quote_m2tk.(flds{i});
                    catch e
                    end
                end
                
                for i = 1:nT
                    for j = 1:nK
                        data(i,j) = HistoricOptQuoteStore();
                    end
                end
                
                for i = 1:nT
                    for j = 1:nK
                        code = quote_m2tk.data(i,j).code;
                        name = quote_m2tk.data(i,j).optName;
                        data(i,j) = HistoricOptQuoteStore(code, name);
                    end
                end
                
                obj.data = data;
            else
                warning('��������M2TK�����Ͳ�ƥ��');
            end
        end
        
        function [success] = record_t_k_quote(obj, nT, nK, quote)
            if ~quote.is_obj_valid
                success = 0;
                return;
            end
            hist_q = obj.data(nT, nK);
            success = hist_q.UpdateQuote(quote);
        end
        
        function [obj] = load_from_file(obj)
            % ��hardcode
            formatT = 'yy-mm-dd';
            date = datestr(obj.currentDate, formatT);
            dir = 'D:\intern\optionClass\���ݺ�����\��ʷ����\';
%             dir = ['C:\Users\Rick Zhu\Documents\Synology Cloud', '\intern\optionClass\���ݺ�����\��ʷ����\'];
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            for i = 1:nT
                for j = 1:nK
                    hist_q = obj.data(i,j);
                    if ~(hist_q.is_obj_valid)
                        continue;
                    end
                    name = hist_q.optName;
                    file_name = [dir, name, '\', date, '.xlsx'];
                    if exist(file_name, 'file')
                        % ���뵱������
                        hist_q.loadExcel(file_name, 'historic_quote');
                    else
                        warning(['�ļ��Ҳ���', file_name]);
                    end
                    
                    %����ǰStep�����顣
                    for delta_t = 1:obj.step
                        date_name = datestr(obj.currentDate - delta_t, formatT);
                        file_name = [dir, name, '\', date_name, '.xlsx'];
                        if exist(file_name, 'file')
                            % ����ǰ������
                            temp_q = HistoricOptQuoteStore(hist_q.optCode, hist_q.optName);
                            temp_q.loadExcel(file_name, 'historic_quote');
                            % merge to hist_q
                            hist_q.merge_prev_quote(temp_q);
                        else
                            warning(['�ļ��Ҳ���', file_name]);
                            break;
                        end
                    end
                end
            end
        end
        
        function [obj] = save_to_file(obj)
            % ÿ��Ʒ�ֿ��Ƿ��Ѿ�������Ŀ¼�ˡ�
            % ����δ����������Ŀ¼��
            formatT = 'yy-mm-dd';
            dir = 'D:\intern\optionClass\���ݺ�����\��ʷ����\';
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            for i = 1:nT
                for j = 1:nK
                    hist_q = obj.data(i,j);
                    if ~hist_q.is_obj_valid()
                        continue;
                    end
                    name = hist_q.optName;
                    date = datestr(obj.currentDate, formatT);
                    opt_dir = [dir, name];
                    if ~exist(opt_dir, 'dir')                        
                        mkdir(opt_dir);
                    end
                    file_name = [opt_dir, '\', date];
                    hist_q.save_currentday_quote(file_name);
                end
            end
            
        end
    end
end