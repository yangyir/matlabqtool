/*
 * ctpmdlogin.cpp is to login ctp market data
 * ctpmdlogin(addr, broker, investor, invest_pwd);
 */

#include "mex.h"
#include "ctp_quote_listener_wrapper.h"
#include <iostream>
#include <vector>

#  pragma comment(lib,"CTP_MarketData.lib")
#  define FUNCTION_CALL_MODE __stdcall

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double * outData;
    plhs[0] = mxCreateDoubleScalar(0);
    outData = mxGetPr(plhs[0]);
    
    if (nrhs < 4)
    {
        mexWarnMsgTxt("usage :¡¡ctpmdlogin('protocol/address', 'broker_id', 'investor_id', 'investor_pwd')");
        outData[0] = 0;
        return;
    }
    
    char * addr = mxArrayToString(prhs[0]);
    char * broker_id = mxArrayToString(prhs[1]);
    char * investor_id = mxArrayToString(prhs[2]);
    char * investor_password = mxArrayToString(prhs[3]);
    
    bool ret = Start(addr, broker_id, investor_id, investor_password);
    if(ret)
    {
        mexWarnMsgTxt("login success");
        outData[0] = 1;
    }
    else
    {
        mexWarnMsgTxt("login failed");
        outData[0] = 0;
    }
    
}

