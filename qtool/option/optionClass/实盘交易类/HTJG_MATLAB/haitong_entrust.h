#ifndef HAITONG_ENTRUST_H
#define HAITONG_ENTRUST_H

#include "Common\dll_config.h"
#include "Common\base_def.h"
#include <stdint.h>
#include <string>

class DLLEXPORT Entrust
{
public:
	Entrust();
	explicit Entrust(uint32_t entrust_id, AssetType entrust_type, \
	    const char * code, int direction, int offset, double price, uint32_t amount);
	char * GetCode();
	uint32_t GetMultiplier();
	uint32_t GetOrderId();
	long GetLocalId();
	char * GetSysId();
	double GetTargetPrice();
	uint32_t GetTargetAmount();
	void SetLocalId(long local_id);
	void SetSysId(const std::string& sys_id);
	int GetDirection();
	int GetOffsetFlag();
	AssetType GetType();


	void Update(const Entrust& other);
	void UpdateDealInfo(uint32_t deal_amount, double deal_price);
	void Cancel();
	void Failed(const std::string& failed_info);
	char * GetFailedInfo();
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
	char entrust_sys_id_[64];
	char asset_code_[32];
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

	char failed_info_[128];

};
#endif // !HAITONG_ENTRUST_H

