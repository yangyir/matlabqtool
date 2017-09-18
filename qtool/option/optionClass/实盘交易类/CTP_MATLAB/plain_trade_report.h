#ifndef PLAIN_TRADE_REPORT_H
#define PLAIN_TRADE_REPORT_H

#ifdef __cplusplus
extern "C"{
#endif

#include <stdint.h>

struct PlainTradeReport
{
    uint64_t trade_id_;
    char code_[64];
    int direction_;
    int open_close_;
    double price_;
    uint32_t  amount_;
    char trade_time_[64];
    char  order_sys_id_[64];
    int  trade_type_;
    int  hedge_flag_;
    int  market_type_;
};

#ifdef __cplusplus
}
#endif

#endif