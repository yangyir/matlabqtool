#ifndef XSPEED_COUNTER_EXPORT_WRAPPER_H
#define XSPEED_COUNTER_EXPORT_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

class XSpeedEntrust;
struct TraderAccountInfo;
struct OptPositionInfo;
struct StockPositionInfo;

#define DLLEXPORT __declspec(dllexport)

bool DLLEXPORT InitCounter(const char* front_addr, const char* investor, const char* pwd , const char* log_path, int& /*output*/ counter_id);
bool DLLEXPORT PlaceEntrust(int counter_id, XSpeedEntrust& entrust);
bool DLLEXPORT WithDrawEntrust(int counter_id, uint64_t entrust_id);
bool DLLEXPORT QryEntrust(int counter_id, uint64_t entrust_id, XSpeedEntrust& entrust);
bool DLLEXPORT QryAccount(int counter_id);
void DLLEXPORT QryPosition(int counter_id);
bool DLLEXPORT GetOptAccountInfo(int counter_id, TraderAccountInfo& account);
bool DLLEXPORT GetStkAccountInfo(int counter_id, TraderAccountInfo& account);
bool DLLEXPORT GetOptPositions(int counter_id, const char* code, int& num_info, OptPositionInfo **addr);
bool DLLEXPORT GetStkPositions(int counter_id, const char* code, int& num_info, StockPositionInfo **addr);
bool DLLEXPORT ReleaseCounter(int counter_id);


#ifdef __cplusplus
}
#endif

#endif