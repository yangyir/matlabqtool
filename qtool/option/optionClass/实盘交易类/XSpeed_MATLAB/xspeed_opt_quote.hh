#ifndef XSPEED_OPT_QUOTE_HH
#define XSPEED_OPT_QUOTE_HH

#include <string>
#define DLLEXPORT __declspec(dllexport)

struct Asset;
struct DFITCStockDepthMarketDataField;
struct DFITCSOPDepthMarketDataField;

class XSpeedOptQuote
{
public:
    XSpeedOptQuote();
    XSpeedOptQuote(const Asset& asset);
    XSpeedOptQuote(const char* code);
    XSpeedOptQuote(struct DFITCSOPDepthMarketDataField * pMarketDataField);
    ~XSpeedOptQuote(){}
    void Update(struct DFITCSOPDepthMarketDataField * pMarketDataField);
    void UpdateETF(struct DFITCStockDepthMarketDataField * pMarketDataField);
    bool Valid(){
    return (!code_.empty() && (last_ != 0));
    }
public:
    std::string code_;
    std::string name_;
    std::string update_time_;
    std::string exchange_name_;
    std::string underlying_code_;
    double strike_;
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