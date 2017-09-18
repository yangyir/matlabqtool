function [positions_array, ret] = queryPositions(self, mktno, type, code)
%function [positions_array, ret] = queryPositions(self, mktno, code)
% code Ϊ��Ĵ��룬�����ÿ��ַ���''Ϊȡ���и����Ͳ�λ��
% type Ϊ�ֲ����ͣ�֧����Ȩ����Ʊ���ڻ��������͡����ͣ�'ETF'/'Option'/'Future'
errorCode = 0;
errorMsg = '';
packet = [];
ret = false;
positions_array = [];
switch(type)
    case 'ETF'
        [errorCode, errorMsg, packet] = self.queryCombiStock(mktno, code);
    case 'Option'
        [errorCode, errorMsg, packet] = self.queryCombiOpt(mktno, code);
    case 'Future'
        [errorCode, errorMsg, packet] = self.queryCombiFuture(mktno, code);
    otherwise
        warning(['not valid type', type]);
end

if errorCode ~= 0
    warning(errorMsg);
else
    positions_array = ParsePostionArrayFromO32Packet(packet);
    ret = true;
end

% ��������PositionArray
end

function [position_array] = ParsePostionArrayFromO32Packet(packet)
    position_array = PositionArray;
    L = packet.getRow() - 1;
    for i = 0 : L
        packet.setCurrRow(i);
        pos_element = Position;
        pos_element.instrumentCode = char(packet.getStr('stock_code'));
        pos_element.instrumentName = char(packet.getStr('stock_name'));
        pos_element.volume = packet.getInt('current_amount');
        if pos_element.volume < 1
            continue;
        end
        pos_element.volumeSellable = packet.getInt('enable_amount');
        pos_flag = str2double(packet.getChar('position_flag'));
        if ~isnan(pos_flag)
            pos_element.longShortFlag = (1.5 - pos_flag) * 2;
        else % ���ҿ�ͷ�ֲ�
            pos_element.longShortFlag = -1;
        end
        pos_element.avgCost = packet.getDouble('current_cost_price');
        pos_element.faceCost = packet.getDouble('current_cost');
        
        position_array.push(pos_element);
    end
end