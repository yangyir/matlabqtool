#ifndef HAITONG_COUNTER_EXPORT_WRAPPER_H
#define HAITONG_COUNTER_EXPORT_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif // !__cplusplus
#include <stdint.h>

class Entrust;
struct TraderAccountInfo;
struct PositionInfo;

#define DLLEXPORT __declspec(dllexport)
	
bool DLLEXPORT InitCounter(const char* server, const char* port, const char* investor, const char* pwd, int& /*output*/ counter_id);
bool DLLEXPORT PlaceEntrust(int counter_id, Entrust& entrust);
bool DLLEXPORT WithDrawEntrust(int counter_id, uint64_t entrust_id, Entrust& entrust);
bool DLLEXPORT QryEntrust(int counter_id, uint64_t entrust_id, Entrust& entrust);
bool DLLEXPORT QryAccount(int counter_id);
void DLLEXPORT QryPosition(int counter_id);
bool DLLEXPORT GetAccountInfo(int counter_id, TraderAccountInfo& account);
bool DLLEXPORT GetPositions(int counter_id, const char* code, int& num_info, PositionInfo **addr);
bool DLLEXPORT ReleaseCounter(int counter_id);

#ifdef __cplusplus
}
#endif // !__cplusplus

#endif // !HAITONG_COUNTER_EXPORT_WRAPPER_H

