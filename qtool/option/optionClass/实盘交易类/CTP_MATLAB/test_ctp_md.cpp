#include "mex.h"
#include "ctp_quote_listener_wrapper.hh"
#include "ctp_quote_listener_config_param.hh"
#include "ctp_asset.hh"
#include <iostream>
#include <vector>

#  pragma comment(lib,"CTP_MarketData.lib")
//#  pragma comment(lib,"thostmduserapi.lib")
#  define FUNCTION_CALL_MODE __stdcall

CTPQuoteListenerWrapper listener;
//#pragma comment(lib, "thostmduserapi.lib")
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    mexWarnMsgTxt("enter test");
    CTPListenerConfigParam param;
    param.front_addr_ = "tcp://125.64.36.26:52213";
    param.broker_id_ = "2001";
    param.investor_id_ = "8880000052";
    param.investor_password_ = "123456";
    CTPQuoteListenerWrapper listener;

//     std::vector<Asset> asset_vector;
//     Asset a("180ETF购6月2905A", "11000613");
//     asset_vector.push_back(a);
//     asset_vector.push_back(Asset("180ETF购6月2954A", "11000614"));
    Asset a[2];
    a[0] = Asset("180ETF购6月2905A", "11000613");
    a[1] = Asset("180ETF购6月2954A", "11000614");

    bool ret = listener.Start(param);
    if(ret)
    {
        mexWarnMsgTxt("login success");
        listener.AddInterestedAsset(a, 2);
    }

//     if(listener.Start(param))
//     {
//         listener.AddInterestedAsset(asset_vector);
//     }
    
    mexWarnMsgTxt("send done");
    listener.Stop();
}

