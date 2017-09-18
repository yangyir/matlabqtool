#ifndef XSPEED_ENTRUST_HH
#define XSPEED_ENTRUST_HH

#include <string>
#include <stdint.h>

#define DLLEXPORT __declspec(dllexport)

#include "xspeed_enum_def.hh"

class DLLEXPORT XSpeedEntrust
{
public:
    XSpeedEntrust();
    explicit XSpeedEntrust(uint32_t entrust_id, AssetType entrust_type,\
        const char* code, int direction, int offset, double price,uint32_t amount);

    std::string GetCode();
    uint32_t GetMultiplier();
    uint32_t GetOrderId();
    long GetLocalId();
    long GetSysId();
    double GetTargetPrice();
    uint32_t GetTargetAmount();
    void SetLocalId(long local_id);
    void SetSysId(long sys_id);
    int GetDirection();
    int GetOffsetFlag();
    AssetType GetType();


    void Update(const XSpeedEntrust& other);
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
    uint32_t entrust_id_;
    AssetType entrust_type_;
    // local_id is xspeed entrust id
    long entrust_local_id_;
    long entrust_sys_id_;
    std::string asset_code_;
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