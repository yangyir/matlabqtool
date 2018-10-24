#ifndef RH_CTP_ENTRUST_HH
#define RH_CTP_ENTRUST_HH

#include <string>
#include <stdint.h>
#include "def_enum.hh"
#include "dll_config.h"
struct CThostFtdcOrderField;

class DLLEXPORT RHEntrust
{
public:
    RHEntrust();
    RHEntrust(uint64_t entrust_id, AssetType entrust_type, const char * code, int direction, int offset, double price, uint32_t amount);
    ~RHEntrust();
public:
	void FillEntrustFromQueryResponse(CThostFtdcOrderField* order_resp);
	void SetOrderId(uint64_t entrust_id);
    void SetOrderRefId(uint64_t ref_id);
    void SetExchangeId(const char* exchange_id);
	void SetEntrustId(uint64_t entrust_id);
	void SetAssetType(AssetType entrust_type);
	void SetAssetCode(const char * code);
	void SetAssetName(const char * name);
	void SetDirection(int direction);
	void SetOffset(int offset);
	void SetPrice(double price);
	void SetAmount(uint32_t amount);
    AssetType GetAssetType();
    char * GetExchangeId();
    char * GetSystemId();
    char * GetCode();
	char * GetName();
    uint32_t GetMultiplier();
    void SetMultiplier( uint32_t multi);
    uint64_t GetOrderId();
    uint64_t GetOrderRef();
    double GetTargetPrice();
    uint32_t GetTargetAmount();
    //TradeDirection GetDirection();
    //TradeOpenCloseFlag GetOffsetFlag();
    int GetDirection();
    int GetOffsetFlag();

    void Update(RHEntrust& other);
    void SetEntrustNo(const std::string& sys_id);
    void UpdateDealInfo(uint32_t deal_amount, double deal_price);
    void Cancel();
    bool isValid();
    bool isClosed();
    bool isInserted();

    // get deal info
    uint32_t GetDealAmount();
    double  GetDealVolume();
    double  GetDealPrice();
    uint32_t GetCancelAmount();
private:
    uint64_t  entrust_ref_;
    uint64_t  entrust_id_;
    char  entrust_no_[32];
    AssetType  entrust_type_;
    char asset_code_[32];
	char asset_name_[32];
    char exchange_id_[32];
    // ºÏÔ¼³ËÊý
    uint32_t multiplier_;
    // buy sell direction
    int direction_;
    // open close flag
    int offsetflag_;
    double target_price_;
    uint32_t target_amount_;

    uint32_t deal_amount_;
    double   deal_volume_;
    double   deal_price_;
    double   deal_num_;

    uint32_t cancel_amount_;
    uint64_t cancel_no_;
};

#endif