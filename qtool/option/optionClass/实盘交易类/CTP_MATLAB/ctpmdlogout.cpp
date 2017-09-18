/*
 * ctpmdlogout.cpp is to login ctp market data
 * ctpmdlogout();
 */

#include "mex.h"
#include "ctp_quote_listener_wrapper.h"
#include <iostream>
#include <vector>

#  pragma comment(lib,"CTP_MarketData.lib")
#  define FUNCTION_CALL_MODE __stdcall

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    Stop();    
    mexWarnMsgTxt("ctp market data logout");
    return;
}

