#ifndef TF_TRADE_STATUS_HH
#define TF_TRADE_STATUS_HH

#include "quote_enum_traits.hh"

const TradeStatus enum_traits<TradeStatus>::enumerators[] = {
    INVALID,
    NORMAL,
    SUSPENDED
};

#endif