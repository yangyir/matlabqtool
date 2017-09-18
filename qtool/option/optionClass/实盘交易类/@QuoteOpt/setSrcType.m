function [ self ] = setSrcType(self, src_type)
% 设置行情源类型，包括恒生：H5, 上期技术：CTP, 飞创：XSpeed
% 对于L2和Wind这两种非实盘情况,暂时不包含在内

    self.srcType = src_type;
end
