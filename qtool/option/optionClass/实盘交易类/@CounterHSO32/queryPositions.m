function [positions_array, ret] = queryPositions(self, mktno, type, code)
%function [positions_array, ret] = queryPositions(self, mktno, code)
% code 为标的代码，可以置空字符串''为取所有该类型仓位。
% type 为持仓类型，支持期权，股票，期货三种类型。类型：'ETF'/'Option'/'Future'
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

% 解包，组成PositionArray
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
        else % 备兑空头持仓
            pos_element.longShortFlag = -1;
        end
        pos_element.avgCost = packet.getDouble('current_cost_price');
        pos_element.faceCost = packet.getDouble('current_cost');
        
        position_array.push(pos_element);
    end
end