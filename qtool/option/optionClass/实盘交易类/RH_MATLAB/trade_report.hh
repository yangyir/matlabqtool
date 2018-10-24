#ifndef TF_TRADE_REPORT_HH
#define TF_TRADE_REPORT_HH

#include <stdint.h>
#include "extern/quote_enum_def.hh"
#include "plain_trade_report.h"
//#include "supported_counter_type.hh"
#include <string>
#define DLLEXPORT __declspec(dllexport)
class DLLEXPORT TradeReport
{
public:
    TradeReport();
    explicit TradeReport(uint64_t trade_id, 
                         std::string code,
                         TradeDirection direction,
                         TradeOpenCloseFlag open_close,
                         double price,
                         uint32_t amount,
                         std::string trade_time,
                         std::string order_sys_id,
                         TradeType trade_type,
                         HedgeFlag hedge_flag,
                         MarketType market_type);
    PlainTradeReport TransformToPlain();
    uint64_t GetTradeId();
    
    std::string& GetStockCode();

    TradeDirection GetDirection();

    TradeOpenCloseFlag GetOpenCloseFlag();

    uint32_t GetFilledAmount();

    std::string& GetSystemId();

    std::string& GetTradeTime();

    double GetPrice();

    TradeType GetTradeType();

    HedgeFlag GetHedgeFlag();

    MarketType GetMarketType();
private:
    uint64_t trade_id_;
    std::string code_;
    TradeDirection direction_;
    TradeOpenCloseFlag open_close_;
    double price_;
    uint32_t  amount_;
    std::string  trade_time_;
    std::string  order_sys_id_;
    TradeType  trade_type_;
    HedgeFlag  hedge_flag_;
    MarketType  market_type_;
};

//typedef boost::function<void (uint64_t,TradeReport&)> TradeNotifier;
#endif