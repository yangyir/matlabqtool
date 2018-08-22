#ifndef TF_STOCK_DEF_HH
#define TF_STOCK_DEF_HH

#include <boost/function.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/bind.hpp>
#include <boost/unordered_map.hpp>
#include <vector>
#include <string>
#include "quote_enum_def.hh"

class StockQuote;
typedef boost::shared_ptr<StockQuote> StockQuotePtr;
typedef boost::function<void (StockQuote&) > QuoteSuccessHandler;
typedef boost::function<void (void)> QuoteFailureHandler;
struct QuoteResponseHandlerSet
{
    QuoteSuccessHandler success_handler_;
    QuoteFailureHandler failure_handler_;
};

struct AssetBase
{
    AssetBase()
        : asset_code_(""),
          asset_name_(""),
          asset_hands_(0),
          asset_market_type_(MARKET_INVALID),
          asset_status_(INVALID)
    {}
    explicit AssetBase(std::string& code, std::string& name, uint32_t hands, MarketType market_type, TradeStatus status)
        : asset_code_(code),
          asset_name_(name),
          asset_hands_(hands),
          asset_market_type_(market_type),
          asset_status_(status)
    {}
    bool Valid()
    {
        return ((asset_market_type_ != MARKET_INVALID) && (asset_status_ != INVALID));
    }
    std::string asset_code_;
    std::string asset_name_;
    uint32_t asset_hands_;
    MarketType asset_market_type_;
    TradeStatus asset_status_;
};

typedef boost::shared_ptr<AssetBase> AssetBasePtr;
// pair of market_type and stock code.
typedef std::pair<int, std::string> Stock;
struct InterestQuote
{
    Stock stock;
    QuoteResponseHandlerSet handler_set;
    StockQuotePtr quote_data;
    AssetBasePtr asset_base;
};

typedef boost::shared_ptr<InterestQuote> InterestQuotePtr;
typedef std::vector<InterestQuote> InterestedStocks;
typedef std::vector<Stock> Stocks;

typedef boost::unordered_map<std::string, InterestQuote> StocksMap;

struct TransactionInfo
{
    explicit TransactionInfo(double price, uint32_t amount, double balance, TradeOperation operation)
        : price_(price),
          amount_(amount),
          balance_(balance),
          operation_(operation)
    {}
    double price_;
    uint32_t amount_;
    double balance_;
    TradeOperation operation_;
};

struct StockInfo
{
    explicit StockInfo(std::string& stock_code)
        : stock_code_(stock_code),
          stock_amount_(0),
          average_price_(0)
    {}
    
    explicit StockInfo(std::string& stock_code, uint64_t stock_amount, double average_price)
        : stock_code_(stock_code),
          stock_amount_(stock_amount),
          average_price_(average_price)
    {}

    void RecordTransaction(double price, uint32_t amount, double balance, TradeOperation operation)
    {
        switch(operation)
        {
        case BID_OPEN:
        case OFFER_OPEN:
            {
                average_price_ = ((average_price_) * stock_amount_ + balance) / (stock_amount_ + amount);
                stock_amount_ += amount;
                break;
            }
        case BID_CLOSE:
        case OFFER_CLOSE:
            {
                average_price_ = ((average_price_) * stock_amount_ - balance) / (stock_amount_ - amount);
                stock_amount_ -= amount;
                break;
            }
        }

        transaction_info_set_.push_back(TransactionInfo(price, amount, balance, operation));
    }
    
    std::string stock_code_;
    uint64_t stock_amount_;
    // average price
    double average_price_; 
    std::vector<TransactionInfo> transaction_info_set_;
};

#endif