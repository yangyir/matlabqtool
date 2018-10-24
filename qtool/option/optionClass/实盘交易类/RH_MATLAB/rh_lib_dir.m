function [ path ] = rh_lib_dir()
%QTOOL_ROOT_DIR 此处显示有关此函数的摘要
%   此处显示详细说明
   path = [fileparts(mfilename('fullpath')),'\'];
end