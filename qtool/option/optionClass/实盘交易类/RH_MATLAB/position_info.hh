#ifndef POSITION_INFO_HH
#define POSITION_INFO_HH

#include <stdint.h>
#include <string>

#define DLLEXPORT __declspec(dllexport)
//#define DLLEXPORT 

typedef enum
{
    TRADE_INVALID,
    TRADE_BUY,
    TRADE_SELL
}TradeBuySellType;


struct DLLEXPORT PositionInfo
{
    PositionInfo();
    PositionInfo(const std::string& code, const std::string& name, char direct, uint32_t total_position, uint32_t available_position, double avg_price, double face_cost, double margin, double fee_cost);
    void Update(const std::string& code, char direct, uint32_t total_position, uint32_t available_position, double avg_price, double face_cost, double margin, double fee_cost);
	void fillPosition(const std::string& code, double face_cost, double fee_cost, char direct, int volume);
	bool merge(const PositionInfo& info);
    char asset_code_[13];
	char asset_name_[64];
    ///�ֲֶ�շ���
    TradeBuySellType trade_direction_;
    ///�ֲܳ�
    uint32_t total_position_;
    /// ���óֲ�
    uint32_t available_position_;
    /// ƽ���۸�
    double avg_price_;
    /// ���ֳɱ�
    double face_cost_;
    ///ռ�õı�֤��
    double margin_;
    /// ���׷���
    double total_fee_cost_;
};


#endif