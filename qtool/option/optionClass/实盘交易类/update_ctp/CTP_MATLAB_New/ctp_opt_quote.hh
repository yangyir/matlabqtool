#ifndef CTP_OPT_QUOTE_HH
#define CTP_OPT_QUOTE_HH

#include <string>
#include "common_def.h"

struct Asset;
struct CThostFtdcDepthMarketDataField;

class DLLEXPORT CTPOptQuote
{
public:
    CTPOptQuote();
    CTPOptQuote(const Asset& asset);
    CTPOptQuote(const char* code);
    ~CTPOptQuote();
    void Update(CThostFtdcDepthMarketDataField *pDepthMarketData);
    bool Valid();
public:
    char code_[64];
    char name_[64];
    char update_time_[64];
    unsigned long pre_settle_;
    unsigned long pre_close_;
    unsigned long open_;
    unsigned long high_;
    unsigned long low_;
    unsigned long last_;
    unsigned long settle_;
	unsigned long open_interest_;
    int amount_;
    unsigned long volume_;
    unsigned long close_;
    unsigned long bid_p1_;
    int    bid_q1_;
    unsigned long bid_p2_;
    int    bid_q2_;
    unsigned long bid_p3_;
    int    bid_q3_;
    unsigned long bid_p4_;
    int    bid_q4_;
    unsigned long bid_p5_;
    int    bid_q5_;

    unsigned long ask_p1_;
    int    ask_q1_;
    unsigned long ask_p2_;
    int    ask_q2_;
    unsigned long ask_p3_;
    int    ask_q3_;
    unsigned long ask_p4_;
    int    ask_q4_;
    unsigned long ask_p5_;
    int    ask_q5_;

    unsigned long avg_p_;
};

#endif