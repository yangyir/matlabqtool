/****
*    the file is to wrapper the real quote listener implementation. 
*    the target is to keep a clean header for external client. 
*    keep the interface clean and loose couple with third party libs and headers.
*/

#ifndef CTP_QUOTE_LISTENER_WRAPPER_HH
#define CTP_QUOTE_LISTENER_WRAPPER_HH

#ifdef __cplusplus
extern "C" {
#endif

#define DLLEXPORT __declspec(dllexport)

class CTPQuoteListener;
struct Asset;
class CTPOptQuote;

bool DLLEXPORT Start(const char * addr, const char* broker_id, const char * investor, const char * password, const char * log_dir, int& quote_src_id);
void DLLEXPORT Stop(int quote_src_id);
void DLLEXPORT AddInterestedAsset(int quote_src_id, const Asset * interested_assets, int num_assets);
void DLLEXPORT NoLongerInterestAsset(int quote_src_id, const Asset * interested_assets, int num_assets);
void DLLEXPORT QueryOptQuote(int quote_src_id, const char * code, CTPOptQuote& quote);

#ifdef __cplusplus
}
#endif
#endif