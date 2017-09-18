/*
 * [counter_id, ret] = xspeedcounterlogin(addr, investor, investor_pwd, log)
 * init the xspeed counter. 
 * if init failed, counter_id is 0;
 */
#include "mex.h"
//#include "matrix.h"
#include "xspeed_counter_export_wrapper.h"

#pragma comment(lib, "XSpeedSECCounterLib.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // input args
    char *addr = NULL;    
    char *investor = NULL;
    char *investor_pwd = NULL;
    char *log = NULL;
    
    addr = mxArrayToString(prhs[0]);
    investor = mxArrayToString(prhs[1]);
    investor_pwd = mxArrayToString(prhs[2]);
    log = mxArrayToString(prhs[3]);
    
    // output values : counter id    
    int counter_id = 0;
    bool ret = InitCounter(addr, investor, investor_pwd, log, counter_id);
    if(ret)
    {        
        mexWarnMsgTxt("Counter Login Success");
    }
    else
    {
        mexWarnMsgTxt("Counter Login Failed");
    }
    plhs[0] = mxCreateDoubleScalar(counter_id);
    plhs[1] = mxCreateLogicalScalar(ret);
    
    return;
}
