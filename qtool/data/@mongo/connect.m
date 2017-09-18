function conn = connect(db,table)
%CONNECT Summary of this function goes here
%   Detailed explanation goes here
MongoStart;
conn=Mongo();
if ~m.isConnected()
   disp('cannot connnect to mongo!');
end

ns=sprintf(['%s.',table], db);
disp('123');
end

