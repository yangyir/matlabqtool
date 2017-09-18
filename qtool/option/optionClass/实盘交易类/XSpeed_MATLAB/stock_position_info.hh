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
    ///�ֲܳ�
    uint32_t total_position_;
    /// ���óֲ�
    uint32_t available_position_;
    /// ƽ���۸�
    double avg_price_;
    /// ���ֳɱ�
    double face_cost_;
    /// ���׷���
    double total_fee_cost_;
};

#endif