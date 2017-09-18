function [ self ] = setSrcId(self, src_id)
%设置Quote类的行情源Id，此域是QMS Version2 引入的，可以同时提供多个行情，用不同ID区分行情源
%为了向前兼容，设定srcId默认值为-1，当默认Id时
self.srcId = src_id;
end