#ifndef CTP_OPT_QUOTE_HH
#define CTP_OPT_QUOTE_HH

#include <string>
#define DLLEXPORT __declspec(dllexport)

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
    double pre_settle_;
    double pre_close_;
    double open_;
    double high_;
    double low_;
    double last_;
    double settle_;
    int amount_;
    double volume_;
    double close_;
    double bid_p1_;
    int    bid_q1_;
    double bid_p2_;
    int    bid_q2_;
    double bid_p3_;
    int    bid_q3_;
    double bid_p4_;
    int    bid_q4_;
    double bid_p5_;
    int    bid_q5_;

    double ask_p1_;
    int    ask_q1_;
    double ask_p2_;
    int    ask_q2_;
    double ask_p3_;
    int    ask_q3_;
    double ask_p4_;
    int    ask_q4_;
    double ask_p5_;
    int    ask_q5_;

    double avg_p_;
};

#endif