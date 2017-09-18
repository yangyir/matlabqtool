#ifndef XSPEED_QUOTE_LISTENER_WRAPPER_H
#define XSPEED_QUOTE_LISTENER_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

#define DLLEXPORT __declspec(dllexport)

struct Asset;
struct XSpeedQuoteStruct;

bool DLLEXPORT Start(const char * addr, const char * investor, const char * password, const char * log_path);
void DLLEXPORT Stop();
void DLLEXPORT AddInterestedOption(const Asset * interested_assets, int num_assets);
void DLLEXPORT AddInterestedStock(const Asset * interested_assets, int num_assets);
void DLLEXPORT NoLongerInterestStock(const Asset * interested_assets, int num_assets);
void DLLEXPORT NoLongerInterestOption(const Asset * interested_assets, int num_assets);
void DLLEXPORT QueryQuote(const char * code, XSpeedQuoteStruct& quote);

#ifdef __cplusplus
}
#endif


#endif