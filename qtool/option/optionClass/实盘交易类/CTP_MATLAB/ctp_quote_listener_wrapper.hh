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
class CTPListenerConfigParam;
struct Asset;
class CTPOptQuote;

class DLLEXPORT CTPQuoteListenerWrapper
{
public:
    CTPQuoteListenerWrapper();
    ~CTPQuoteListenerWrapper();
    bool Start(const CTPListenerConfigParam& param);
    void Stop();
    void AddInterestedAsset(const Asset * interested_assets, int num_assets);
    void NoLongerInterestAsset(const Asset * interested_assets, int num_assets);
    void QueryOptQuote(const char * code, CTPOptQuote& quote);
private:
    CTPQuoteListener& impl_;
};

#ifdef __cplusplus
}
#endif
#endif