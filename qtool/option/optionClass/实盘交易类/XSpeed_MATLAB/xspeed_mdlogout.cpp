#include "mex.h"
#include "xspeed_quote_listener_wrapper.h"
#include <iostream>
#include <vector>

#  pragma comment(lib,"XSpeedSECQuoteLib.lib")
#  define FUNCTION_CALL_MODE __stdcall

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    Stop();    
    mexWarnMsgTxt("xspeed market data logout");
    return;
}
