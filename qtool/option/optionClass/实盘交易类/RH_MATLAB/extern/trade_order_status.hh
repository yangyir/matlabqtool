#ifndef TF_TRADE_ORDER_STATUS_HH
#define TF_TRADE_ORDER_STATUS_HH

#include "quote_enum_traits.hh"

const TradeOrderStatus enum_traits<TradeOrderStatus>::enumerators[] =
{
    NOT_REPORTED,
    WAIT_FOR_REPORTING,
    REPORTED,
    REPORTED_WAIT_FOR_WITHDRAW,
    PARTIALLY_FILLED_WAIT_FOR_WITHDRAW,
    PARTIALLY_WITHDRAW,
    WITHDRAW,
    PARTIALLY_FILLED,
    FILLED,
    INVALID_ENTRUST,
    WITHDRAW_INVALID,
    UNDEFINE

};


#endif