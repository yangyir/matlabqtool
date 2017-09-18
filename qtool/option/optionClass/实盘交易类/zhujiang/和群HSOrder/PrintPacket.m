function PrintPacket(packet)
    import com.hundsun.esb.data.*;
    %fprintf('�ܼ�¼����%d\n',packet.getRecordCount());
    %fprintf('������%d, ������%d\n',packet.getCol(),packet.getRow());        
    %fprintf('���������ݣ�\n');
    for i = 0 : packet.getCol() -1                 
        fprintf('%s\t',char(packet.getColumnName(i)));
    end;
    fprintf('\n');
    for i=0: packet.getRow()-1
        packet.setCurrRow(i);
        for j=0: packet.getCol()-1
          switch packet.getColumnType(j)
              case FieldType.DATATYPE_CHAR                  
                  fprintf('%c\t',packet.getCharByIndex(j));
              case FieldType.DATATYPE_DOUBLE
                  fprintf('%f\t',packet.getDoubleByIndex(j));         
              case FieldType.DATATYPE_INT
                  fprintf('%d\t',packet.getIntByIndex(j));  
              case FieldType.DATATYPE_STRING
                  fprintf('%s\t',char(packet.getStrByIndex(j)));  
              case FieldType.DATATYPE_BINARY
                  fprintf('RAW\t');                    
          end;
        end;
        fprintf('\n');
    end;    
end