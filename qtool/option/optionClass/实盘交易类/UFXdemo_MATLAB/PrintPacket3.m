
function str = PrintPacket3( packet )
% 纵向打印，更容易看清楚
% ----------------------
% 吴云峰，20150302,修改为Str的方法

import com.hundsun.esb.data.*;
%fprintf('总记录数：%d\n',packet.getRecordCount());
%fprintf('列数：%d, 行数：%d\n',packet.getCol(),packet.getRow());
%fprintf('以下是数据：\n');

str = '';

for i=0: packet.getRow()-1
    packet.setCurrRow(i);
    for j=0: packet.getCol()-1
        str = sprintf('%s[%d]%s\t', str , j,char(packet.getColumnName(j)));
        str = sprintf('%s[%d]', str , j );
        switch packet.getColumnType(j)
            case FieldType.DATATYPE_CHAR
                str = sprintf('%s%c\t' , str , packet.getCharByIndex(j));
            case FieldType.DATATYPE_DOUBLE
                str = sprintf('%s%f\t', str , packet.getDoubleByIndex(j));
            case FieldType.DATATYPE_INT
                str = sprintf('%s%d\t',str , packet.getIntByIndex(j));
            case FieldType.DATATYPE_STRING
                str = sprintf('%s%s\t',str , char(packet.getStrByIndex(j)));
            case FieldType.DATATYPE_BINARY
                str = sprintf('%sRAW\t', str);
        end;
        str = sprintf( '%s\n' , str );
    end;
end;



end

