#ifndef XSPEED_ENUM_DEF_HH
#define XSPEED_ENUM_DEF_HH

typedef enum
{
    INVALID_ASSET_TYPE,
    FUTURE,
    OPTION,
    ETF
}AssetType;

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
    CLOSE_TODAY
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
    EXCHANGE_SH,
    EXCHANGE_SZ
}ExchangeType;


#endif