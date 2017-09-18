#include "mex.h"
#include "xspeed_quote_listener_wrapper.h"
#include <iostream>
#include <vector>

#  pragma comment(lib,"XSpeedSECQuoteLib.lib")
#  define FUNCTION_CALL_MODE __stdcall

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double * outData;
    plhs[0] = mxCreateDoubleScalar(0);
    outData = mxGetPr(plhs[0]);
    
    if (nrhs < 4)
    {
        mexWarnMsgTxt("usage :¡¡xspeedmdlogin('protocol/address', 'broker_id', 'investor_id', 'investor_pwd')");
        outData[0] = 0;
        return;
    }
    
    char * addr = mxArrayToString(prhs[0]);
    char * investor_id = mxArrayToString(prhs[1]);
    char * investor_password = mxArrayToString(prhs[2]);
    char * log_path = mxArrayToString(prhs[3]);
    
    bool ret = Start(addr, investor_id, investor_password, log_path);
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
