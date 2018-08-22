#ifndef TF_TRADE_EXECUTION_INFO_HH
#define TF_TRADE_EXECUTION_INFO_HH

#include <string>

struct ExecutionInfo
{
    ExecutionInfo(){}
    ExecutionInfo(const std::string& exection_id, const std::string& execution_time)
        : order_execution_id_(exection_id),
          execution_time_(execution_time)
    {}
    std::string order_execution_id_;
    std::string execution_time_;
};

#endif