
function str = PrintPacket3( packet )
% �����ӡ�������׿����
% ----------------------
% ���Ʒ壬20150302,�޸�ΪStr�ķ���

import com.hundsun.esb.data.*;
%fprintf('�ܼ�¼����%d\n',packet.getRecordCount());
%fprintf('������%d, ������%d\n',packet.getCol(),packet.getRow());
%fprintf('���������ݣ�\n');

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

