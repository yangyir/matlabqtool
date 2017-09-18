/*
 * [counter_id] = jg_counterlogin(addr, port, investor, investor_pwd)
 * init the ctp counter. 
 * if init failed, counter_id is 0;
 */
#include "mex.h"
#include "haitong_counter_export_wrapper.h"

#pragma comment(lib, "HaiTongAccess.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // input args
    char *addr = NULL;
    char *port = NULL;
    char *investor = NULL;
    char *investor_pwd = NULL;
    
    addr = mxArrayToString(prhs[0]);
    port = mxArrayToString(prhs[1]);
    investor = mxArrayToString(prhs[2]);
    investor_pwd = mxArrayToString(prhs[3]);
    
    // output values : counter id    
    int counter_id = 0;
    bool ret = InitCounter(addr, port, investor, investor_pwd, counter_id);
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
