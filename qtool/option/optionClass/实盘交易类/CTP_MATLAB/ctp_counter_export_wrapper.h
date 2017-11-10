/*
 * ctp_counter_export header file is a c-style api header. 
 * it is to integrate with matlab or other lib user easily.
 * it is just a wrapper of ctp counter manager service's functionalities.
 */


#ifndef CTP_COUNTER_EXPORT_WRAPPER_H
#define CTP_COUNTER_EXPORT_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

class CTPEntrust;
struct TraderAccountInfo;
struct PositionInfo;
struct PlainTradeReport;

#define DLLEXPORT __declspec(dllexport)
//#define DLLEXPORT 

bool DLLEXPORT InitCounter(const char* front_addr, const char* broker, const char* investor, const char* pwd , const char* product_info, const char* authentic_code, int& /*output*/ counter_id);
bool DLLEXPORT PlaceEntrust(int counter_id, CTPEntrust& entrust);
bool DLLEXPORT WithDrawEntrust(int counter_id, uint64_t entrust_id);
bool DLLEXPORT QryEntrust(int counter_id, uint64_t entrust_id, CTPEntrust& entrust);
bool DLLEXPORT QryAccount(int counter_id);
void DLLEXPORT QryPosition(int counter_id);
bool DLLEXPORT GetAccountInfo(int counter_id, TraderAccountInfo& account);
bool DLLEXPORT GetPositions(int counter_id, const char* code, int& num_info, PositionInfo **addr);
void DLLEXPORT QuerySettlementInfo(int counter_id, const char* trade_day, const char * settle_info_path);
void DLLEXPORT QueryAllOrder(int counter_id, int& num_entrust, CTPEntrust **entrusts);
void DLLEXPORT QueryAllTrade(int counter_id);
bool DLLEXPORT GetAllTrades(int counter_id, int& num_trades, PlainTradeReport** trades);
bool DLLEXPORT ReleaseCounter(int counter_id);


#ifdef __cplusplus
}
#endif

#endif