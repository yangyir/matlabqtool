#ifndef STOCK_POSITION_INFO_HH
#define STOCK_POSITION_INFO_HH

#define DLLEXPORT __declspec(dllexport)
#include <stdint.h>
#include <string>

struct DLLEXPORT StockPositionInfo
{
    StockPositionInfo();
    explicit StockPositionInfo(const std::string& code, const std::string& name, uint32_t total_position, uint32_t available_position, double avg_price, double face_cost, double fee_cost);
    void Update(const std::string& code, const std::string& name, uint32_t total_position, uint32_t available_position, double avg_price, double face_cost, double fee_cost);
    char asset_code_[13];
    char asset_name_[64];
    ///总持仓
    uint32_t total_position_;
    /// 可用持仓
    uint32_t available_position_;
    /// 平均价格
    double avg_price_;
    /// 开仓成本
    double face_cost_;
    /// 交易费用
    double total_fee_cost_;
};

#endif