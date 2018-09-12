#ifndef TF_QUOTE_ENUM_DEF_HH
#define TF_QUOTE_ENUM_DEF_HH

//#include <string>
//#include <algorithm>
//#include <boost/variant.hpp>

typedef enum
{
    INVALID_DIRECTION,
    BULL,
    BEAR
}TradeDirection;

typedef enum
{
    INVALID_OPERATION,
    BID_OPEN,
    BID_CLOSE,
    BID_CLOSE_TODAY,
    OFFER_OPEN,
    OFFER_CLOSE,
    OFFER_CLOSE_TODAY
}TradeOperation;

typedef enum
{
    INVALID_OPEN_CLOSE_FLAG,
    OPEN,
    CLOSE,
    CLOSE_TODAY,
    CLOSE_YESTERDAY
}TradeOpenCloseFlag;

typedef enum
{
    INVALID_TRADE_TYPE,
    COMMON,
    OPTIONS_EXECUTION,
    OTC,
    EFPDERIVED,
    COMBINATION_DERIVED
}TradeType;

typedef enum
{
    INVALID_HEDEG_FLAG,
    SPECULATION,
    HEDGE
}HedgeFlag;

typedef enum
{
    INVALID_TRADE_TACTIC,
    TARGET_LIMIT_PRICE,
    COUNTERPARTY_PRICE,
    REMUNERATIVE_PRICE_LEVEL,
    CONSESSION_FIXED_AMOUNT,
    CONSESSION_PERCENT,
    CONSESSION_LEVELS,
    MARKET_PRICE
}TradeTactic;

//typedef boost::variant<boost::blank, double, uint32_t> TacticParam;

typedef enum
{
    NOT_REPORTED = '0',
    WAIT_FOR_REPORTING = '1',
    REPORTED = '2',
    REPORTED_WAIT_FOR_WITHDRAW = '3',
    PARTIALLY_FILLED_WAIT_FOR_WITHDRAW = '4',
    PARTIALLY_WITHDRAW = '5',
    WITHDRAW = '6',
    PARTIALLY_FILLED = '7',
    FILLED = '8',
    INVALID_ENTRUST = '9',
    WITHDRAW_INVALID = 'A',
    UNDEFINE = 'W'
}TradeOrderStatus;

typedef enum
{
    SUSPEND,
    ENTRUST,
    REPLENISH,
    WITHDRAWING,
    PARTIALLYFILLED,
    FULLFILLED,
    PARTIALLYWITHDRAWED,
    FULLWITHDRAWED,
    CLOSED
}OrderStatus;

typedef enum 
{
    INVALID = -1,
    NORMAL = 0,
    SUSPENDED = 1
}TradeStatus;

typedef enum
{
    MARKET_INVALID = -1,
    MARKET_SH_L1 = 0x101,
    MARKET_SH_L2 = 0x202,
    MARKET_SZ_L1 = 0x102,
    MARKET_SZ_L2 = 0x202,
    MARKET_FUTURE_CFFE = 0x303,
    MARKET_FUTURE_SHFE = 0x304,
    MARKET_FUTURE_DLCE = 0x305,
    MARKET_FUTURE_ZZCE = 0x306,
    MARKET_FUTURE_ZHHY = 0x30c,
    MARKET_NEEQ = 0x10b,
    MARKET_SH_INDIVIDUAL_STOCK_OPTION = 0xd01,
    MARKET_SZ_INDIVIDUAL_STOCK_OPTION = 0xd02,
    MARKET_INDEX_OPTION_CFFE = 0x1103,
    MARKET_OPTION_SHFE = 0x1104,
    MARKET_OPTION_DLCE = 0x1105,
    MARKET_OPTION_ZZCE = 0x1106
}MarketType;

//template <typename T>
//struct enum_traits
//{
//   
//};
//
//template<typename T, std::size_t N>
//T *endof(T (&ra)[N])
//{
//    return ra + N;
//}

#endif