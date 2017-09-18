#ifndef TF_POSITION_INFO_DEF_HH
#define TF_POSITION_INFO_DEF_HH
#include <stdint.h>
#include <string>

typedef enum
{
    TRADE_INVALID,
    TRADE_BUY,
    TRADE_SELL
}TradeBuySellType;


struct PositionInfo
{
    PositionInfo(const std::string& code, char direct, uint32_t total_position, uint32_t yesterday_position, uint32_t today_position, double cost, double margin, double close_profit, double hold_profit)
        : asset_code_(code),
          trade_direction_(TRADE_INVALID),
          total_position_(total_position),
          yesterday_position_(yesterday_position),
          today_position_(today_position),
          position_cost_(cost),
          margin_(margin),
          close_profit_(close_profit),
          hold_profit_(hold_profit)
    {
        if('2' == direct)
        {
            trade_direction_ = TRADE_BUY;
        }
        else if('3' == direct)
        {
            trade_direction_ = TRADE_SELL;
        }
        else
        {
            trade_direction_ = TRADE_INVALID;
        }
    }
    std::string asset_code_;
    ///持仓多空方向
    TradeBuySellType trade_direction_;
    ///总持仓
    uint32_t total_position_;
    ///上日持仓
    uint32_t yesterday_position_;
    ///今日持仓
    uint32_t today_position_;
    ///持仓成本
    double position_cost_;
    ///占用的保证金
    double margin_;
    ///平仓盈亏
    double close_profit_;
    ///持仓盈亏
    double hold_profit_;
};

struct InvestorFundInfo
{
    InvestorFundInfo(double pre_deposite,
                    double pre_margin, 
                    double current_margin,
                    double frozen_margin,
                    double close_profit,
                    double position_profit,
                    double commission,
                    double available_fund)
        : close_profit_(close_profit),
          position_profit_(position_profit),
          commission_(commission),
          available_fund_(available_fund),
          current_margin_(current_margin),
          frozen_margin_(frozen_margin),
          pre_interest_(pre_deposite + pre_margin),
          present_interest_(current_margin_ + position_profit_ + available_fund_ - commission_),
          close_profit_rate_(close_profit_ / current_margin_),
          position_profit_rate_(position_profit_ / present_interest_)
    {
    }
    
    double close_profit_;
    double position_profit_;

    double commission_;
    double available_fund_;
    
    double current_margin_;
    double frozen_margin_;

    // 期初权益
    double pre_interest_;
    double present_interest_;

    double close_profit_rate_;
    double position_profit_rate_;
};


#endif